class ApplicationController < ActionController::Base
  def initialize
    super
    # TODO - write real authentication and session code, maybe in a separate
    # subclass - like SessionController. In the meantime, here's a User for
    # all controllers to use.
    @user = User.first
  end

  def olcc_client
    @olcc_client ||= OlccWeb::Client.new(Rails.logger)
  end

  protected

  def check_and_setup_user
    # this is overriding @user set in initialize
    if user_signed_in?
      @user = current_user
    else
      @user = nil   # XXX - remove this eventually
      flash[:error] = "You must be logged in to access this section"
      redirect_to home_url
    end
  end
end
