require "rails_helper"
require_relative "../../test/test_helper"

RSpec.describe OlccStore do
  let(:user) { create :user }
  let(:store) { create :olcc_store }

  describe "a user favorites a store" do
    it "should increment the follower count" do
      expect(store.followers_count).to eq(0)

      user.favorite_stores = [store]

      store.reload
      expect(store.followers_count).to eq(1)
    end

    it "should increment the count when another user favorites the store" do
      new_user = create(:user, email: "alice@test.com")
      user.favorite_stores = [store]

      new_user.favorite_stores = [store]

      store.reload
      expect(store.followers_count).to eq(2)
    end
  end

  describe "a user unfavors a store" do
    before(:each) { user.favorite_stores = [store] }

    it "should decrement the count when a user unfavors a store" do
      user.favorite_stores = []
      store.reload
      expect(store.followers_count).to eq(0)
    end
  end
end
