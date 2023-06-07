require "rails_helper"
require_relative "../../test/test_helper"

RSpec.describe UpdateCategoryBottles do
  it "inserts a new bottle and creates an event" do
    client = double("olcc-client")
    new_bottle = Dto::BottleData.new(
      category: "RUM", new_item_code: "111", old_item_code: "222B",
      description: "New Hooch", size: "666 ML", proof: 69, age: "13yrs", bottle_price: 69.69
    )
    expect(client).to receive(:get_category_bottles).and_return([new_bottle])

    expect { UpdateCategoryBottles.call(client, "RUM") }
      .to change { OlccBottle.count }.by(1)
      .and change { BottleEvent.count }.by(1)

    b = OlccBottle.find(new_bottle.new_item_code)
    expect(b.old_item_code).to eq(new_bottle.old_item_code)
    expect(b.name).to eq(b.description)
    event = b.bottle_events.last
    expect(event.event_type).to eq("NEW BOTTLE")
  end

  it "should update an existing bottle and create an event" do
    barcelo = create(:olcc_bottle)
    new_code = barcelo.new_item_code
    old_code = barcelo.old_item_code
    new_desc = "BARCELO ANEJO"
    new_age = "13 yrs"
    new_price = 32.95
    client = double("olcc-client")
    new_bottle = Dto::BottleData.new(
      category: "RUM", new_item_code: new_code, old_item_code: old_code,
      description: new_desc, size: barcelo.size, proof: barcelo.proof,
      age: new_age, bottle_price: new_price
    )
    expect(client).to receive(:get_category_bottles).and_return([new_bottle])

    expect { UpdateCategoryBottles.call(client, "RUM") }
      .to change { OlccBottle.count }.by(0)  # i.e., no change
      .and change { BottleEvent.count }.by(1)

    barcelo.reload
    expect(barcelo.description).to eq(new_desc)
    expect(barcelo.name).to eq(new_desc.titleize)
    expect(barcelo.age).to eq(new_age)
    expect(barcelo.bottle_price).to eq(new_price)

    event = barcelo.bottle_events.last
    expect(event.event_type).to eq("DESCRIPTION CHANGE")
    changes = event.details
    expect(changes["age"].last).to eq(new_age)
    expect(changes["bottle_price"].last).to eq(new_price.to_s)
  end

  it "should update the price an existing bottle and create an event" do
    barcelo = create(:olcc_bottle)
    new_code = barcelo.new_item_code
    old_code = barcelo.old_item_code
    new_price = 132.95
    client = double("olcc-client")
    new_bottle = Dto::BottleData.new(
      category: "RUM", new_item_code: new_code, old_item_code: old_code,
      description: barcelo.description, size: barcelo.size, proof: barcelo.proof,
      age: barcelo.age, bottle_price: new_price
    )
    expect(client).to receive(:get_category_bottles).and_return([new_bottle])

    expect { UpdateCategoryBottles.call(client, "RUM") }
      .to change { OlccBottle.count }.by(0)  # i.e., no change
      .and change { BottleEvent.count }.by(1)

    barcelo.reload
    expect(barcelo.bottle_price).to eq(new_price)

    event = barcelo.bottle_events.last
    expect(event.event_type).to eq("PRICE CHANGE")
    expect(event.details["bottle_price"].last).to eq(new_price.to_s)
  end

  it "should not create an event if there are no changes" do
    barcelo = create(:olcc_bottle)
    client = double("olcc-client")
    new_bottle = Dto::BottleData.new(
      category: "RUM", new_item_code: barcelo.new_item_code, old_item_code: barcelo.old_item_code,
      description: barcelo.description, size: barcelo.size, proof: barcelo.proof,
      age: barcelo.age, bottle_price: barcelo.bottle_price
    )
    expect(client).to receive(:get_category_bottles).and_return([new_bottle])

    expect { UpdateCategoryBottles.call(client, "RUM") }.to_not change { BottleEvent.count }
  end
end
