class HomeController < ApplicationController
  def index
    # NB: when rendering events related to stores, we're triggering an N+1
    # query of the stores
    @events = BottleEvent.recents(@user.following_bottle_ids)
  end
end
