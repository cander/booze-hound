class UserController < ApplicationController
  def index
    @user = User.first
  end
end
