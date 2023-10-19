# As a User (with preferred/local stores) I want to know what stores have a
# bottle I'm looking for from my short-list of stores.
# Returns OlccInventory records with the OlccStores eagerly loaded.
# We do not handle ordering by distance with the idea that the list of
# stores is already winnowed down to a manageable size.
class StoreQuery < ApplicationService
  def initialize(bottle_code, stores)
    @bottle_code = bottle_code
    # stores were optional when we didn't have a way to keep track of a user's
    # favorite stores. Might bring that back if we ever want to search
    # across all stores - looking far afield for something.
    @stores = stores
  end

  def call
    result = OlccInventory.includes(:olcc_store).in_stock
      .where(new_item_code: @bottle_code, store_num: @stores)
    # if we joined store, we should be able to sort on name in the DB
    result.sort { |x, y| x.olcc_store.name <=> y.olcc_store.name }
  end
end
