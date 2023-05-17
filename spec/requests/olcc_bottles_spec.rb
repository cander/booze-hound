require "rails_helper"

RSpec.describe "OlccBottles", type: :request do
  let(:user) { build_stubbed(:user) }
  let(:fav_stores) { [1, 2, 3] }
  let(:followed_bots) { [4, 5, 6] }
  let(:store) { build_stubbed(:olcc_store) }
  let(:bottle) { build_stubbed(:olcc_bottle) }

  before do
    expect(User).to receive(:first).and_return(user)
  end

  describe "GET /index" do
    it "returns http success" do
      expect(user).to receive(:following_bottle_ids).and_return(followed_bots)
      expect(OlccBottle).to receive(:find).with(followed_bots).and_return([])

      get "/olcc_bottles"

      expect(response).to have_http_status(:success)
    end
    it "queries for a bottle by name" do
      bottle_name = "Duke"
      expect(OlccBottle).to receive(:search).with(bottle_name).and_return([])
      get "/olcc_bottles", params: {query: bottle_name}

      expect(response).to have_http_status(:success)
    end
  end

  describe "SHOW <bottle-id>" do
    it "returns http success" do
      bottle_id = "123"
      expect(OlccBottle).to receive(:find).with(bottle_id).and_return(bottle)
      expect(user).to receive(:favorite_store_ids).and_return(fav_stores)
      expect(StoreQuery).to receive(:call).with(bottle, fav_stores).and_return([])

      get olcc_bottle_url(bottle_id)

      expect(response).to have_http_status(:success)
      # expect(response).to render_template(:show)
    end
  end
end
