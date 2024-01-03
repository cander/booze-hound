
class RegistrationsController < Devise::RegistrationsController

  protected

  def update_resource(resource, params)
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
      resource.update_without_password(params)
    else
      # if the password is provided, allow changing any attribute
      # this could be modified to remove attributes we don't want to change
      super
    end
  end
end
