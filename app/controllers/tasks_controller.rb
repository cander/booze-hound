class TasksController < ApplicationController
  TOKEN = if Rails.env.test?
    "test"
  else
    ENV["TASKS_TOKEN"]
  end

  before_action :authenticate

  def daily
    response.headers["Content-Type"] = "text/event-stream"
    if Rails.env.test?
      response.stream.write "OK\n"
      return
    end

    client = OlccWeb::Client.new(Rails.logger)
    count = OlccBottle.count
    UpdateCategoryBottles.call(client, "DOMESTIC WHISKEY")
    response.stream.write "Found #{OlccBottle.count - count} new bottles\n"
    count = OlccInventory.count
    UpdateAllInventory.call(client)
    response.stream.write "There are now #{OlccInventory.count - count} new inventory records\n"
  ensure
    response.stream.close
  end

  private

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      ActiveSupport::SecurityUtils.secure_compare(token, TOKEN)
    end
  end
end
