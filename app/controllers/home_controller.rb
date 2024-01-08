class HomeController < ApplicationController
  def index
    @user = current_user   # may be nil if not logged in

    get_user_events(params[:page])
  end

  # eventually, this event code should be a separate controller
  def get_user_events(page_str)
    page = if page_str
      page_str.to_i
    else
      0
    end

    if page > 0
      @next_page = page + 1
      @prev_page = page - 1
    else
      page = 0
      @next_page = 1
    end

    # NB: when rendering events related to stores, we're triggering an N+1
    # query of the stores. We can't just includes(:stores) because there
    # is no relation from events to stores b/c the store
    # is in the JSON and not every event has a store.
    # In theory, this won't be bad b/c recent events are limited and we're
    # using SQLite, so everything is in memory - no DB server round-trips.
    # We could create some sort of helper/service to
    # fetch all the stores into a hash that could be consulted if it were a problem.
    @events = if user_signed_in?
      BottleEvent.recents(current_user.following_bottle_ids, current_user.get_categories, page)
    else
      # in theory, only signed-in user should get to the home controller,
      # but will leave it open for the moment while the UI is in some flux.
      # Later, when user's have preferred categories, it really won't make sense.
      []
    end
  end
end
