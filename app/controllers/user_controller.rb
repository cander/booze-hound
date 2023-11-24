class UserController < ApplicationController
  def index
    if helpers.user_signed_in?
      @user = helpers.current_user
    else
      redirect_to "/"
    end
  end

  def show
    @user = User.first
  end
end
