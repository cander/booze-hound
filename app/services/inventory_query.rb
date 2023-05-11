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
    # what if we joined instead of including? We could sort by bottle name
    # someday we'll want/need pagination, in which case sorting and pagination
    # needs to be handled by DB, which means joining.
    result = OlccInventory.in_stock.includes(:olcc_bottle).where(store_num: @stores)
    result = result.where(new_item_code: @bottles) unless @bottles.empty?

    result
  end
end
