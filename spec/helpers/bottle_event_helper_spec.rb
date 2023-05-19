require "rails_helper"

# Specs in this file have access to a helper object that includes
# the BottleEventHelper.

RSpec.describe BottleEventHelper, type: :helper do
  describe "show_event" do
    it "should render new inventory in mixed case" do
      evt = build_stubbed(:bottle_event, event_type: "NEW BOTTLE")
      expect(helper.show_event(evt)).to eq("New bottle")
    end
    it "should render the store number for new inventory" do
      store = create(:olcc_store)
      dets = {store_num: store.store_num}
      evt = build_stubbed(:bottle_event, event_type: "NEW INVENTORY", details: dets)
      expect(helper.show_event(evt)).to eq("arrived at #{store.name}")
    end
    it "should render a price change" do
      dets = {bottle_price: ["39.95", "49.95"]}
      evt = build_stubbed(:bottle_event, event_type: "PRICE CHANGE", details: dets)
      expect(helper.show_event(evt)).to eq("price changed from $39.95 to $49.95")
    end
    it "should render a description change" do
      dets = {"name" => ["STAGG JR.", "STAGG"]}
      evt = build_stubbed(:bottle_event, event_type: "DESCRIPTION CHANGE", details: dets)
      expect(helper.show_event(evt)).to eq("description changed - name")
    end
  end
end
