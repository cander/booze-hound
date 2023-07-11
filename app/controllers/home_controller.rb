class HomeController < ApplicationController
  def index
    # NB: when rendering events related to stores, we're triggering an N+1
    # query of the stores. We can't just includes(:stores) because there
    # is no relation from events to stores b/c the store
    # is in the JSON and not every event has a store.
    # In theory, this won't be bad b/c recent events are limited.
    # We could create some sort of helper/service to
    # fetch all the stores into a hash that could be consulted.
    @events = BottleEvent.recents(@user.following_bottle_ids)
  end
end
