

class InventoryQuery < ApplicationService
  def initialize(store_nums, bottles)
    @store_nums = store_nums
    @bottles = bottles
  end

  def call
    # query for the user's bottles in a store (or stores?)
    # initially just query for all OLCC bottles in a store
    OlccInventory.in_stock.where(store_num: @store_nums)
  end
end
