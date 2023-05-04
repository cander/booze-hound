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

  it "should update inventory of an existing bottle in a store w/o an event" do
    inv = create(:olcc_inventory, olcc_bottle: bottle, olcc_store: store)
    expect(client).to receive(:get_item_inventory).and_return([inv_dto(5)])

    expect { UpdateBottleInventory.call(client, bottle) }
      .to change { OlccInventory.count }.by(0) # neither is changing
      .and change { BottleEvent.count }.by(0)

    new_inv_count = inv.reload.quantity
    expect(new_inv_count).to eq(5)
  end

  it "should zero the quantity for stores missing from inventory" do
    inv = create(:olcc_inventory, olcc_bottle: bottle, olcc_store: store)
    expect(client).to receive(:get_item_inventory).and_return([])

    expect { UpdateBottleInventory.call(client, bottle) }
      .to change { OlccInventory.count }.by(0) # neither is changing
      .and change { BottleEvent.count }.by(0)

    new_inv_count = inv.reload.quantity
    expect(new_inv_count).to eq(0)
  end

  it "should create an event when a bottle first arrives at a store" do
    expect(client).to receive(:get_item_inventory).and_return([inv_dto(13)])

    expect { UpdateBottleInventory.call(client, bottle) }
      .to change { OlccInventory.count }.by(1)
      .and change { BottleEvent.count }.by(1)

    event = bottle.bottle_events.last
    expect(event.event_type).to eq("NEW INVENTORY")
  end

  it "should create an event when the quanity increases from zero" do
    inv = create(:olcc_inventory, quantity: 0, olcc_bottle: bottle, olcc_store: store)
    new_qty = 6

    expect(client).to receive(:get_item_inventory).and_return([inv_dto(new_qty)])
    expect { UpdateBottleInventory.call(client, bottle) }
      .to change { OlccInventory.count }.by(0)
      .and change { BottleEvent.count }.by(1)

    new_inv_count = inv.reload.quantity
    expect(new_inv_count).to eq(new_qty)
  end
end
