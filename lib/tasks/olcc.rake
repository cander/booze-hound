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
end
