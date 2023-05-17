class OlccBottlesController < ApplicationController
  def index
    if params[:query]
      @olcc_bottles = OlccBottle.search(params[:query])
      @query = params[:query]
    else
      # should this be a service because it spans mulltiple objects?
      @olcc_bottles = OlccBottle.find(@user.following_bottle_ids)
    end
    # might want two different views for my bottles vs. search bottles
    # with the option to start following bottles in search results
  end

  def show
    @bottle = OlccBottle.find(params[:id])
    @inventory = StoreQuery.call(@bottle, @user.favorite_store_ids)
  end
end
