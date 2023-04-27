require "rails_helper"
require_relative "../../test/test_helper"

RSpec.describe UpdateBottleInventory do
  let(:bottle) { create :olcc_bottle }
  let(:store) { create :olcc_store }
  let(:client) { double "olcc-client" }

  def inv_dto(qty)
    Dto::InventoryData.new(
      new_item_code: bottle.new_item_code, store_num: store.store_num,
      quantity: qty
    )
  end

  it "should create an event when a bottle first arrives at a store" do
    expect(client).to receive(:get_item_inventory).and_return([inv_dto(13)])

    expect { UpdateBottleInventory.call(client, bottle) }
      .to change { OlccInventory.count }.by(1)
      .and change { BottleEvent.count }.by(1)

    event = bottle.bottle_events.last
    expect(event.event_type).to eq("NEW INVENTORY")
  end

  it "should update inventory of an existing bottle in a store" do
    # should be possible to create an inventory in a factory
    OlccInventory.create!(store_num: store.store_num, new_item_code: bottle.new_item_code, quantity: 1)
    new_qty = 6

    expect(client).to receive(:get_item_inventory).and_return([inv_dto(new_qty)])
    expect { UpdateBottleInventory.call(client, bottle) }
      .to change { OlccInventory.count }.by(0)  # two counts are not changing
      .and change { BottleEvent.count }.by(0)

    new_inv_count = InventoryQuery.call(store, [bottle]).first.quantity
    expect(new_inv_count).to eq(new_qty)
  end

  it "should create an event when the quanity increases from zero" do
    # should be possible to create an inventory in a factory
    OlccInventory.create!(store_num: store.store_num, new_item_code: bottle.new_item_code, quantity: 0)
    new_qty = 6

    expect(client).to receive(:get_item_inventory).and_return([inv_dto(new_qty)])
    expect { UpdateBottleInventory.call(client, bottle) }
      .to change { OlccInventory.count }.by(0)
      .and change { BottleEvent.count }.by(1)

    new_inv_count = InventoryQuery.call(store, [bottle]).first.quantity
    expect(new_inv_count).to eq(new_qty)
  end
end
