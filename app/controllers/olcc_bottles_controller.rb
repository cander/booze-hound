class OlccBottlesController < ApplicationController
  # for now, all operations require login
  before_action :check_and_setup_user

  def index
    if params[:query]
      @olcc_bottles = OlccBottle.search(params[:query])
      @query = params[:query]
    else
      @olcc_bottles = UserBottlesQuery.call(current_user)
    end
    # might want two different views for my bottles vs. search bottles
    # with the option to start following bottles in search results
  end

  def show
    @bottle = OlccBottle.find(params[:id])
    @inventory = StoreQuery.call(@bottle, current_user.favorite_store_ids)
  end

  def update
    @bottle = OlccBottle.find(params[:id])
    if params[:olcc_bottle][:follow] == "true"
      UserFollowBottle.call(olcc_client, current_user, @bottle)
    else
      current_user.unfollow_bottle(@bottle)
    end

    redirect_to @bottle
  end

  def create
    new_item_code = clean_item_code_param(:new_item_code)
    category = params[:category]  # sanitize?
    unless new_item_code && category
      flash[:notice] = "An error occurred finding that bottle. Sorry."
      redirect_back(fallback_location: root_path)
      return
    end

    bottle = LoadBottle.call(olcc_client, category, new_item_code)
    if bottle
      # success - show it
      redirect_to bottle
    else
      # Could get the error_message from LoadBottle - maybe someday
      flash[:notice] = "An error occurred finding bottle #{new_item_code}. Sorry."
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def clean_item_code_param(key)
    val = "" && params[key].strip
    if /^\d+$/.match?(val)
      val
    end
  end
end
