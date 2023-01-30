

class InventoryQuery < ApplicationService
  # TODO: consider optional, named parameters
  def initialize(store_nums, bottle_codes)
    @store_nums = store_nums
    @bottle_codes = bottle_codes
  end

  def call
    # query for the user's bottles in a store (or stores?)
    # initially just query for all OLCC bottles in a store
    result = OlccInventory.in_stock.where(store_num: @store_nums)
    result = result.where(new_item_code: @bottle_codes) unless @bottle_codes.empty?

    result
  end
end
