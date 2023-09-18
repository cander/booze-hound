class OlccBottlesController < ApplicationController
  def index
    if params[:query]
      @olcc_bottles = OlccBottle.search(params[:query])
      @query = params[:query]
    else
      @olcc_bottles = UserBottlesQuery.call(@user)
    end
    # might want two different views for my bottles vs. search bottles
    # with the option to start following bottles in search results
  end

  def show
    @bottle = OlccBottle.find(params[:id])
    @user_follows = @user.is_following?(@bottle)
    @inventory = if @user_follows
      StoreQuery.call(@bottle, @user.favorite_store_ids)
    else
      # NB: objects returned are DTOs not Models
      # Causes problems trying to get the store from a bottle. We might not even know of the store
      olcc_client.get_item_inventory(@bottle.category, @bottle.new_item_code, @bottle.old_item_code)
    end
  end

  def update
    @bottle = OlccBottle.find(params[:id])
    if params[:olcc_bottle][:follow] == "true"
      UserFollowBottle.call(olcc_client, @user, @bottle)
    else
      @user.unfollow_bottle(@bottle)
    end

    redirect_to @bottle
  end
end
