require "rails_helper"
require_relative "../../test/test_helper"

RSpec.describe OlccBottle do
  let(:user) { create :user }
  let(:bottle) { create :olcc_bottle }

  describe "a user follows a bottle" do
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

  describe "a user stops following a bottle" do
    before(:each) { user.following_bottles = [bottle] }
    it "should decrement the count when a user unfollows a bottle" do
      user.following_bottles = []
      bottle.reload
      expect(bottle.followers_count).to eq(0)
    end
  end

  describe "updating description" do
    it "should update the name based on the new description" do
      bottle.update(description: "A FINE RUM")
      bottle.reload

      expect(bottle.name).to eq("A Fine Rum")
    end
    it "should not update a non-default name" do
      non_default_name = "An OK Rum"
      bottle.update(name: non_default_name)
      bottle.update(description: "A FINE RUM")
      bottle.reload

      expect(bottle.name).to eq(non_default_name)
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

  describe "next_bottle_price syncronization" do
    let(:next_price) { 33.44 }

    describe "during bottle creation" do
      def unsaved_bottle
        OlccBottle.new(
          new_item_code: "99900592775",
          description: "BARCELO IMPERIAL",
          old_item_code: "5927B",
          category: "RUM",
          size: "750 ML",
          proof: 80.0,
          age: "",
          bottle_price: 11.22
        )
      end

      it "should set next price from current price" do
        bottle = unsaved_bottle
        bottle.save

        expect(bottle.next_bottle_price).to eq(bottle.bottle_price)
      end

      it "should leave next price alone if it is set" do
        bottle = unsaved_bottle
        bottle.next_bottle_price = next_price
        bottle.save

        expect(bottle.next_bottle_price).to eq(next_price)
      end
    end

    describe "during bottle updates" do
      it "should leave next price alone when updating next price" do
        bottle.next_bottle_price = next_price
        bottle.save

        expect(bottle.next_bottle_price).to eq(next_price)
      end

      it "should leave next price alone when updating something other than price" do
        bottle.next_bottle_price = next_price
        bottle.save
        bottle.description = "yummy"
        bottle.save

        expect(bottle.next_bottle_price).to eq(next_price)
      end

      it "should update next price when updating current price" do
        bottle.bottle_price = next_price
        bottle.save

        expect(bottle.next_bottle_price).to eq(next_price)
      end

      it "should leave next price alone when updating both prices" do
        bottle.next_bottle_price = next_price
        bottle.bottle_price = 69.0
        bottle.save

        expect(bottle.next_bottle_price).to eq(next_price)
      end
    end
  end
end
