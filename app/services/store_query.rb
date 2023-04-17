# As a User (with preferred/local stores) I want to know what stores have a
# bottle I'm looking for from my short-list of stores.
# Returns OlccInventory records with the OlccStores eagerly loaded.
# We do not handle ordering by distance with the idea that the list of
# stores is already winnowed down to a manageable size.
class StoreQuery < ApplicationService
  def initialize(bottle_code, stores = nil)
    @bottle_code = bottle_code
    @stores = stores  # currently optional, but not long term
  end

  def call
    result = OlccInventory.includes(:olcc_store).in_stock.where(new_item_code: @bottle_code)
    result = result.where(store_num: @stores) unless @stores.nil?

    result
  end
end
