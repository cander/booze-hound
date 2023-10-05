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

  describe "SHOW <store-id>" do
    it "returns http success" do
      store_id = "123"
      expect(OlccStore).to receive(:find).with(store_id).and_return(store)
      expect(user).to receive(:following_bottle_ids).and_return(followed_bots)
      expect(InventoryQuery).to receive(:call).with([store], followed_bots).and_return([])

      get olcc_store_url(store_id)

      expect(response).to have_http_status(:success)
    end
  end

  describe "UPDATE <store-num>" do
    it "favors the store and redirects to show page" do
      store_num = store.store_num
      expect(OlccStore).to receive(:find).with(store_num).and_return(store)
      expect(user).to receive(:favor_store).with(store)

      patch olcc_store_url(store_num), params: {olcc_store: {follow: "true"}}

      expect(response).to redirect_to(olcc_store_url(store))
    end

    it "unfavors the store and redirects to show page" do
      store_num = store.store_num
      expect(OlccStore).to receive(:find).with(store_num).and_return(store)
      expect(user).to receive(:unfavor_store).with(store)

      patch olcc_store_url(store_num), params: {olcc_store: {follow: "false"}}

      expect(response).to redirect_to(olcc_store_url(store))
    end
  end
end
