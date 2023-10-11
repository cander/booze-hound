class UserStoresQuery < ApplicationService
  def initialize(user)
    @user = user
  end

  def call
    OlccStore.where(store_num: @user.favorite_store_ids).order(:name)
  end
end
