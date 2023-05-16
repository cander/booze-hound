class OlccStoresController < ApplicationController
  def index
    @olcc_stores = OlccStore.find(@user.favorite_store_ids)
  end

  def show
    @store = OlccStore.find(params[:id])
    # TODO: sort the inventory by the name on the bottle, which isn't on inventory
    @inventory = InventoryQuery.call([@store], @user.following_bottle_ids)
  end
end
