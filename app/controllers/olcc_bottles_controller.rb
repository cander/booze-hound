class OlccBottlesController < ApplicationController
  def index
    @olcc_bottles = OlccBottle.followed_bottles
  end

  def show
    @bottle = OlccBottle.find(params[:id])
    # Someday, the store (second parameter) will be based on user's prefernences
    @inventory = StoreQuery.call(@bottle, nil)
  end
end
