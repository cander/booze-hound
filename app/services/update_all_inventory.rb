class UpdateAllInventory < ApplicationService
  def initialize(client)
    @client = client
  end

  def call
    bottles = OlccBottle.followed_bottles
    bottles.each do |b|
      puts "updating: #{b.name}"
      UpdateBottleInventory.call(@client, b)
    end

    true
  end
end
