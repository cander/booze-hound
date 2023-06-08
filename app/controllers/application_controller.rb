class ApplicationController < ActionController::Base
  def initialize
    super
    # TODO - write real authentication and session code, maybe in a separate
    # subclass - like SessionController. In the meantime, here's a User for
    # all controllers to use.
    @user = User.first
  end

  def self.olcc_client
    # Q: should this be a class variable? It's worthwhile to cache them
    # across all controllers - just one in the app, maybe. OTOH, does this
    # mess up testing? I remember some craziness with class variables in
    # dev/test vs. production.
    @@olcc_client ||= OlccWeb::Client.new(Rails.logger)
  end

  def olcc_client
    ApplicationController.olcc_client
  end
end
