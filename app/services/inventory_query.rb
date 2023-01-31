# As a User (with preferred stores and bottles), I want to know what bottles
# are available in a store/stores
# Returns a OlccInventory records for bottles that are in-stock
# TODO: consider optional, named parameters - initialize(stores: [],  bottles: []),
# or both parameters are always required
class InventoryQuery < ApplicationService
  def initialize(stores, bottles)
    @stores = stores
    @bottles = bottles
  end

  def call
    result = OlccInventory.in_stock.where(store_num: @stores)
    result = result.where(new_item_code: @bottles) unless @bottles.empty?

    result
  end
end
