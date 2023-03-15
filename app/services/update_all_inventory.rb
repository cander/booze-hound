class UpdateAllInventory < ApplicationService
  def initialize(client)
    @client = client
  end

  def call
    bottles = OlccBottle.followed_bottles
    bottles.each do |b|
      logger.info { "Updating bottle inventory for: #{b.new_item_code} - #{b.name}" }
      UpdateBottleInventory.call(@client, b)
    end

    true
  end
end
