require "rails_helper"
require_relative "../../test/test_helper"

RSpec.describe OlccBottle do
  let(:bottle) { create :olcc_bottle }
  describe "new_bottle" do
    it "should create a NEW BOTTLE event" do
      expect { BottleEvent.new_bottle(bottle, {}) }.to change { BottleEvent.count }.by 1
      expect(BottleEvent.last.event_type).to eq("NEW BOTTLE")
    end
  end

  describe "udpate_bottle" do
    it "should create a PRICE CHANGE event for a change in price only" do
      bottle.bottle_price = 123.45
      changes = bottle.changes_to_save

      expect { BottleEvent.update_bottle(bottle, changes) }.to change { BottleEvent.count }.by 1
      expect(BottleEvent.last).to be_PRICE_CHANGE
    end
    it "should create a DESCRIPTION CHANGE event for a change something other than price" do
      bottle.name = "fire water"
      changes = bottle.changes_to_save

      expect { BottleEvent.update_bottle(bottle, changes) }.to change { BottleEvent.count }.by 1
      expect(BottleEvent.last).to be_DESCRIPTION_CHANGE
    end
  end
  describe "new_bottle" do
    it "should create NEW BOTTLE event" do
      expect { BottleEvent.new_bottle(bottle, {}) }.to change { BottleEvent.count }.by 1
      expect(BottleEvent.last).to be_NEW_BOTTLE
    end
  end

  describe "recents" do
    it "should return a recent new bottle event for any bottle" do
      BottleEvent.new_bottle(bottle, {})

      events = BottleEvent.recents([])

      expect(events.size).to eq(1)
    end
    it "should ignore old events" do
      BottleEvent.new_bottle(bottle, {})
      BottleEvent.last.update(created_at: 2.weeks.ago)

      events = BottleEvent.recents([], 1.week.ago)

      expect(events.size).to eq(0)
    end
    it "should ignore other events for bottles we're not following" do
      bottle.name = "fire water"
      changes = bottle.changes_to_save
      BottleEvent.update_bottle(bottle, changes)
      other = create(:olcc_bottle, new_item_code: "112233", name: "navy rum", bottle_price: 12.34)
      other.name = "marine rum"
      changes = bottle.changes_to_save
      BottleEvent.update_bottle(other, changes)

      events = BottleEvent.recents([bottle.new_item_code])

      expect(events.size).to eq(1)
      expect(events.last.new_item_code).to eq(bottle.new_item_code)
    end
  end
end
