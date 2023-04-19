require "rails_helper"
require_relative "../../test/test_helper"

RSpec.describe UpdateCategoryBottles do
  it "inserts a new bottle" do
    client = double("olcc-client")
    new_bottle = Dto::BottleData.new(
      category: "RUM", new_item_code: "111", old_item_code: "222B", name: "New Hooch", size: "666 ML", proof: 69, age: "13yrs", bottle_price: 69.69, followed: false
    )
    expect(client).to receive(:get_category_bottles).and_return([new_bottle])

    expect { UpdateCategoryBottles.call(client, "RUM") }.to change { OlccBottle.count }.by 1
    b = OlccBottle.find(new_bottle.new_item_code)
    expect(b.old_item_code).to eq(new_bottle.old_item_code)
    expect(b.followed).to be false
  end

  it "should update an existing bottle" do
    barcello = create(:olcc_bottle)
    new_code = barcello.new_item_code
    old_code = barcello.old_item_code
    new_name = "Barcello Anejo"
    new_age = "13 yrs"
    new_price = 32.95
    client = double("olcc-client")
    new_bottle = Dto::BottleData.new(
      category: "RUM", new_item_code: new_code, old_item_code: old_code, name: new_name, size: barcello.size, proof: barcello.proof, age: new_age, bottle_price: new_price, followed: false
    )
    expect(client).to receive(:get_category_bottles).and_return([new_bottle])

    expect { UpdateCategoryBottles.call(client, "RUM") }.to_not change { OlccStore.count }

    barcello.reload
    expect(barcello.name).to eq(new_name)
    expect(barcello.age).to eq(new_age)
    expect(barcello.bottle_price).to eq(new_price)
  end
end
