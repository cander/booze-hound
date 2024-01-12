class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Additional flash types beyond info and alert are defined here
  add_flash_types :welcome

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

  def after_sign_in_path_for(resource)
    # After sign in, this flash is added to welcome the user
    flash[:welcome] = "Welcome, " + current_user.first_name + "!"
    root_url
  end

  protected

  def configure_permitted_parameters
    # devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :username])
  end
end
