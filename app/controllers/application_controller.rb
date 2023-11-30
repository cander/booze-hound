class ApplicationController < ActionController::Base
  def olcc_client
    @olcc_client ||= OlccWeb::Client.new(Rails.logger)
  end

  protected

  def check_and_setup_user
    # this is overriding @user set in initialize
    if user_signed_in?
      @user = current_user
    else
      flash[:error] = "You must be logged in to access this section"
      redirect_to home_url
    end
  end
end
