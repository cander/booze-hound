class OlccStoresController < ApplicationController
  def index
    if params[:query]
      @olcc_stores = OlccStore.search(params[:query])
      @query = params[:query]
    else
      @olcc_stores = UserStoresQuery.call(@user)
    end
  end

  def show
    @store = OlccStore.find(params[:id])
    # TODO: sort the inventory by the name on the bottle, which isn't on inventory
    @inventory = InventoryQuery.call([@store], @user.following_bottle_ids)
  end

  def update
    @store = OlccStore.find(params[:id])
    if params[:olcc_store][:follow] == "true"
      @user.favor_store(@store)
    else
      @user.unfavor_store(@store)
    end

    redirect_to @store
  end
end
