class UserController < ApplicationController
  def index
    @user = User.first
  end

  def show
    @user = User.first
  end
end
