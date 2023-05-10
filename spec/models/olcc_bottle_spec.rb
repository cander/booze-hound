require "rails_helper"
require_relative "../../test/test_helper"

RSpec.describe OlccBottle do
  let(:user) { create :user }
  let(:bottle) { create :olcc_bottle }
  context "a user follows a bottle" do
    it "should increment the follower count" do
      expect(bottle.followers_count).to eq(0)

      user.following_bottles = [bottle]

      bottle.reload
      expect(bottle.followers_count).to eq(1)
    end

    it "should increment the count when another user follows the bottle" do
      new_user = create(:user, email: "alice@test.com")
      user.following_bottles = [bottle]

      new_user.following_bottles = [bottle]

      bottle.reload
      expect(bottle.followers_count).to eq(2)
    end
  end
  context "a user stops following a bottle" do
    before(:each) { user.following_bottles = [bottle] }
    it "should decrement the count when a user unfollows a bottle" do
      user.following_bottles = []
      bottle.reload
      expect(bottle.followers_count).to eq(0)
    end
  end
end
