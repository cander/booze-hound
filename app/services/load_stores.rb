class LoadStores < ApplicationService
  def initialize(client, city)
    @client = client
    @city = city
  end

  def call
    stores = @client.get_city_stores(@city)
    stores_as_hashes = stores.map { |s| s.deconstruct_keys(nil) }
    OlccStore.upsert_all(stores_as_hashes)
  end
end
