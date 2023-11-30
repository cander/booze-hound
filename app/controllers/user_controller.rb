class UserController < ApplicationController
  # for now, all operations require login. Eventually creating a user won't
  # require the user to be logged in, of course.
  before_action :check_and_setup_user

  def index
    # At the moment, this we don't have this function (list of users)
    redirect_to root_path
  end

  def show
    # NB: we're abusing this method at the moment - to keep it RESTful, we have
    # a user ID coming in, but we don't need it because we know the user's ID from
    # the login session. So, the ID is "me", and we just use current_user.
    @user = current_user
  end
end
