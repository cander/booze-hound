require "rails_helper"
require_relative "../../test/test_helper"

RSpec.describe User do
  let(:bottle) { create :olcc_bottle }
  let(:user) { create :user }

  describe "is_following?" do
    it "it should be false before following any bottles" do
      expect(user.is_following?(bottle)).to be false
    end

    it "should be true after following a bottle" do
      user.follow_bottle(bottle)

      expect(user.is_following?(bottle)).to be true
      bottle.reload
      expect(bottle.followers_count).to eq(1)
    end
  end

  describe "follow_bottle" do
    it "should be safe (a nop) to follow more than once" do
      user.follow_bottle(bottle)
      user.follow_bottle(bottle)

      expect(user.is_following?(bottle)).to be true
      bottle.reload
      expect(bottle.followers_count).to eq(1)
    end
  end

  describe "unfollow_bottle" do
    it "should be safe (a nop) to unfollow more than once" do
      user.follow_bottle(bottle)

      user.unfollow_bottle(bottle)
      user.unfollow_bottle(bottle)
      expect(user.is_following?(bottle)).to be false
      bottle.reload
      expect(bottle.followers_count).to eq(0)
    end

    it "should be safe (a nop) to unfollow a bottle we're not even following" do
      user.unfollow_bottle(bottle)

      expect(user.is_following?(bottle)).to be false
      bottle.reload
      expect(bottle.followers_count).to eq(0)
    end
  end
end
