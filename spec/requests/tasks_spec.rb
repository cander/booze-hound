require "rails_helper"

RSpec.describe "Tasks", type: :request do
  def auth_get(path)
    get path, headers: {Authorization: "Bearer test"}
  end
  describe "GET /daily" do
    it "returns http success when authenticated" do
      auth_get "/tasks/daily"

      expect(response).to have_http_status(:success)
    end

    it "returns http unauthorized without authentication" do
      get "/tasks/daily"

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
