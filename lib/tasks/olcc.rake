namespace :olcc do
  desc "Load store information in a city"
  task :load_city, [:city] => :environment do |t, args|
    city = args[:city].upcase
    puts "Load the stores in #{city}"
    puts "There are initially #{OlccStore.count} stores in the database"
    client = OlccWeb::Client.new(Rails.logger)
    LoadStores.call(client, city)
    puts "There are now #{OlccStore.count} stores in the database"
  end

  desc "Update the inventory for all bottles we're following"
  task update_inventory: :environment do |t, args|
    puts "Updating inventory..."
    puts "There are initially #{OlccInventory.count} inventory records"
    client = OlccWeb::Client.new(Rails.logger)
    UpdateAllInventory.call(client)
    puts "There are now #{OlccInventory.count} records"
  end

  desc "Run the daily updates for everything we're following"
  task daily_update: :environment do |t, args|
    client = OlccWeb::Client.new(Rails.logger)
    count = OlccBottle.count
    UpdateCategoryBottles.call(client, "DOMESTIC WHISKEY")
    puts "Found #{OlccBottle.count - count} new bottles"
    count = OlccInventory.count
    UpdateAllInventory.call(client)
    puts "There are now #{OlccInventory.count - count} new inventory records"
  end
end
