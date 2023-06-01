class TasksController < ApplicationController
  TOKEN = if Rails.env.test?
    "test"
  else
    ENV["TASKS_TOKEN"]
  end

  before_action :authenticate

  def daily
    render plain: "OK\n\n"
  end

  private

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      ActiveSupport::SecurityUtils.secure_compare(token, TOKEN)
    end
  end
end
