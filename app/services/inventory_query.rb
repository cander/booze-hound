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
    # we are joining in the DB and including in a second query.
    # It would be nice if we could bring back all the joined rows and use them
    # in the views. As I recall, there's a way to do that - later.
    result = OlccInventory.in_stock.joins(:olcc_bottle).where(store_num: @stores)
    result = result.where(new_item_code: @bottles) unless @bottles.empty?
    result.order(:category).order(:name).includes(:olcc_bottle)
  end
end
