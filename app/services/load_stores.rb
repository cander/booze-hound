class LoadStores < ApplicationService
  def initialize(client, city)
    @client = client
    @city = city
  end

  def call
    stores = @client.get_city_stores(@city)
    stores_as_hashes = stores.map { |s| s.to_h }
    add_names(stores_as_hashes)
    OlccStore.upsert_all(stores_as_hashes)
  end

  # private-ish
  def add_names(store_hashes)
    if store_hashes.size == 1
      store = store_hashes.first
      name = ActiveSupport::Inflector.titleize(store[:location])
      store[:name] = name
    else
      store_hashes.each do |store|
        # TODO: parse the address to extract out just the street name
        name = ActiveSupport::Inflector.titleize(store[:location]) + " - #{store[:store_num]}"
        store[:name] = name
      end
    end
  end
end
