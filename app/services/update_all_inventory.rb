class UpdateAllInventory < ApplicationService
  def initialize(client)
    @client = client
  end

  def call
    start_time = Time.now
    bottles = OlccBottle.followed_bottles
    logger.info { "Begin updating inventory for #{bottles.count} bottles" }
    bottles.each do |b|
      logger.info { "Updating bottle inventory for: #{b.new_item_code} - #{b.name}" }
      UpdateBottleInventory.call(@client, b)
    end
    logger.info { "Done updating inventory in #{Time.now - start_time} seconds" }

    true
  end
end
