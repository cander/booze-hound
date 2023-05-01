class UpdateAllInventory < ApplicationService
  def initialize(client)
    @client = client
    @last_op_time = 0
  end

  def call
    start_time = Time.now
    bottles = OlccBottle.followed_bottles
    logger.info { "Begin updating inventory for #{bottles.count} bottles" }
    bottles.each do |b|
      rate_limit
      logger.info { "Updating bottle inventory for: #{b.new_item_code} - #{b.name}" }
      UpdateBottleInventory.call(@client, b)
    end
    logger.info { "Done updating inventory of #{bottles.count} bottles in #{Time.now - start_time} seconds" }

    true
  end

  # private-ish
  @@ops_per_sec = 5.0

  def rate_limit
    return if @@ops_per_sec <= 0
    delay = @last_op_time.to_f - Time.now.to_f + (1 / @@ops_per_sec)
    if delay > 0
      sleep(delay)
    end
    @last_op_time = Time.now
  end

  # useful for testing
  def self.disable_rate_limiting
    @@ops_per_sec = 0
  end
end
