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

  describe "prettify_name" do
    it "should titleize the description when no name is provided" do
      expect(bottle.prettify_name).to be true
      expect(bottle.name).to eq(bottle.description.titleize)
    end
    it "should set name to the provided name" do
      bottle.name = "Replace Me"
      new_name = "Great Rum"

      expect(bottle.prettify_name(new_name)).to be true
      expect(bottle.name).to eq(new_name)
    end
    it "should not replace a non-default name" do
      orig_name = "Great Rum"
      bottle.name = orig_name
      bottle.save

      expect(bottle.prettify_name).to be true
      expect(bottle.name).to eq(orig_name)
    end
  end
end
