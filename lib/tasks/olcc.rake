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
    DailyUpdate.call(client, $stdout)
  end

  desc "Download next month's price data and apply it"
  task fetch_next_months_prices: :environment do |t, args|
    ProcessNextMonth.call(Rails.logger)
  end

  desc "Pretty up the names of all bottles"
  task prettify_bottles: :environment do |t, args|
    OlccBottle.all.each { |b| b.prettify_name }
  end
end
