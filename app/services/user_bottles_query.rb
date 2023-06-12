class UserBottlesQuery < ApplicationService
  def initialize(user)
    @user = user
  end

  def call
    OlccBottle.where(new_item_code: @user.following_bottle_ids).order(:name)
  end
end
