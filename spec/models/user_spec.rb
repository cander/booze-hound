require "rails_helper"
require_relative "../../test/test_helper"

RSpec.describe User do
  let(:user) { create :user }

  describe "username constraints" do
    # arguably, these tests are unnecessary - re-testing Rails validations
    def new_user(name)
      result = User.new(user.attributes)
      result.username = name
      result.password = "password"

      result
    end

    it "should be at least 3 characters long" do
      bad_u = new_user("to")

      expect(bad_u.valid?).to be false
      expect(bad_u.errors[:username].first).to match(/too short/)
    end

    it "should be no more than 24 characters long" do
      bad_u = new_user("x" * 25)

      expect(bad_u.valid?).to be false
      expect(bad_u.errors[:username].first).to match(/too long/)
    end

    it "should allow a-zA-Z0-9._- " do
      good_u = new_user("Ab09._-")
      good_u.email = "unqiue@email.com"

      expect(good_u.valid?).to be true
    end

    it "should not allow characters other than a-zA-Z0-9._- " do
      bad_u = new_user("Joe#%")

      expect(bad_u.valid?).to be false
      expect(bad_u.errors[:username].first).to match(/only allows/)
    end
  end

  describe "User and Bottles" do
    let(:bottle) { create :olcc_bottle }

    describe "#is_following?" do
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

    describe "#follow_bottle" do
      it "should be safe (a nop) to follow more than once" do
        user.follow_bottle(bottle)
        user.follow_bottle(bottle)

        expect(user.is_following?(bottle)).to be true
        bottle.reload
        expect(bottle.followers_count).to eq(1)
      end
    end

    describe "#unfollow_bottle" do
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

  describe "User and Stores" do
    let(:store) { create :olcc_store }

    describe "#is_favorite_store?" do
      it "it should be false before favoring any stores" do
        expect(user.is_favorite_store?(store)).to be false
      end

      it "should be true after favoring a store" do
        user.favor_store(store)

        expect(user.is_favorite_store?(store)).to be true
        store.reload
        expect(store.followers_count).to eq(1)
      end
    end

    describe "#favor_store" do
      it "should be safe (a nop) to favor more than once" do
        user.favor_store(store)
        user.favor_store(store)

        expect(user.is_favorite_store?(store)).to be true
        store.reload
        expect(store.followers_count).to eq(1)
      end
    end

    describe "#unfavor_store" do
      it "should be safe (a nop) to unfavor more than once" do
        user.favor_store(store)

        user.unfavor_store(store)
        user.unfavor_store(store)
        expect(user.is_favorite_store?(store)).to be false
        store.reload
        expect(store.followers_count).to eq(0)
      end

      it "should be safe (a nop) to unfavor a store we haven't favored" do
        user.unfavor_store(store)

        expect(user.is_favorite_store?(store)).to be false
        store.reload
        expect(store.followers_count).to eq(0)
      end
    end
  end
end
