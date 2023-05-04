class OlccBottlesController < ApplicationController
  def index
    if params[:query]
      @olcc_bottles = OlccBottle.search(params[:query])
      @query = params[:query]
    else
      @olcc_bottles = OlccBottle.followed_bottles
    end
    # might want two different views for my bottles vs. search bottles
    # with the option to start following bottles in search results
  end

  def show
    @bottle = OlccBottle.find(params[:id])
    # Someday, the store (second parameter) will be based on user's prefernences
    @inventory = StoreQuery.call(@bottle, nil)
  end
end
