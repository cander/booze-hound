require "rails_helper"

RSpec.describe "OlccStores", type: :request do
  let(:user) { build_stubbed(:user) }
  let(:fav_stores) { [1, 2, 3] }
  let(:followed_bots) { [4, 5, 6] }
  let(:store) { build_stubbed(:olcc_store) }

  context "user logged in" do
    before do
      # expect(User).to receive(:first).and_return(user)
      sign_in user
    end

    describe "GET /index" do
      it "returns http success" do
        expect(UserStoresQuery).to receive(:call).with(user).and_return([])

        get "/olcc_stores"

        expect(response).to have_http_status(:success)
      end

      it "queries for a store by name" do
        store_name = "Dallas"
        expect(OlccStore).to receive(:search).with(store_name).and_return([])
        get "/olcc_stores", params: {query: store_name}

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

  describe "anonymous user" do
    def expect_redirect_and_flash
      expect(response).to redirect_to(home_url)
      expect(request.flash[:error]).to_not be_nil
    end

    it "GET /index redirects to home" do
      get "/olcc_stores"

      expect_redirect_and_flash
    end

    it "SHOW <store-id> redirects to home" do
      get olcc_store_url(123)

      expect_redirect_and_flash
    end

    it "UPDATE <store-num> redirects to home" do
      patch olcc_store_url(123), params: {olcc_store: {follow: "true"}}

      expect_redirect_and_flash
    end
  end
end
