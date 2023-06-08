class UserFollowBottle < ApplicationService
  def initialize(client, user, bottle)
    @client = client
    @user = user
    @bottle = bottle
  end

  def call
    @user.follow_bottle(@bottle)
    # Someday this could be asynchronous, in the background. OTOH, after
    # following a bottle, the user probably wants to know immediately which
    # stores it's in, so synchronous seems somewhat reasonable.
    UpdateBottleInventory.call(@client, @bottle) if @bottle.followers_count == 1
  end
end
