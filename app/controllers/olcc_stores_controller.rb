class OlccStoresController < ApplicationController
  def index
    @olcc_stores = OlccStore.all
  end

  def show
    @store = OlccStore.find(params[:id])
    # TODO: sort the inventory by the name on the bottle, which isn't on inventory
    # Someday, the bottles (second parameter) will be based on user's prefernences
    @inventory = InventoryQuery.call([@store], [])
  end
end
