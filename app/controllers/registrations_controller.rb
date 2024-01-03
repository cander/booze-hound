
class RegistrationsController < Devise::RegistrationsController

  protected

  def update_resource(resource, params)
    # TODO: check if password is present
    resource.update_without_password(params)
  end
end
