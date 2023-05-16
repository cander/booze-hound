require "rails_helper"

RSpec.describe "OlccStores", type: :request do
  let(:user) { build_stubbed(:user) }
  let(:fav_stores) { [1, 2, 3] }
  let(:followed_bots) { [4, 5, 6] }
  let(:store) { build_stubbed(:olcc_store) }

  before do
    expect(User).to receive(:first).and_return(user)
  end
  describe "GET /index" do
    it "returns http success" do
      expect(user).to receive(:favorite_store_ids).and_return(fav_stores)
      expect(OlccStore).to receive(:find).with(fav_stores).and_return([])

      get "/olcc_stores"

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /<store-id>" do
    it "returns http success" do
      expect(OlccStore).to receive(:find).with("123").and_return(store)
      expect(user).to receive(:following_bottle_ids).and_return(followed_bots)
      expect(InventoryQuery).to receive(:call).with([store], followed_bots).and_return([])

      get "/olcc_stores/123"

      expect(response).to have_http_status(:success)
    end
  end
end
