class HomeController < ApplicationController
  def index
    @events = BottleEvent.recents
  end
end
