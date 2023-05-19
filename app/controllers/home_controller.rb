class HomeController < ApplicationController
  def index
    @events = BottleEvent.recents(@user.following_bottle_ids)
  end
end
