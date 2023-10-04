require "rails_helper"
require_relative "../../test/test_helper"

RSpec.describe User do
  let(:user) { create :user }

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
