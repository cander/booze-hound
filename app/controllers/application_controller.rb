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
end
