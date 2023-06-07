require "rails_helper"
require_relative "../../test/test_helper"

RSpec.describe LoadBottle do
  it "should insert a bottle" do
    client = double("olcc-client")
    new_bottle = Dto::BottleData.new(
      category: "RUM", new_item_code: "111", old_item_code: "222B",
      description: "New Hooch", size: "666 ML", proof: 69, age: "13yrs", bottle_price: 69.69
    )
    expect(client).to receive(:get_bottle_details).and_return(new_bottle)

    expect { LoadBottle.call(client, "RUM", "111", "222") }.to change { OlccBottle.count }.by 1

    bottle = OlccBottle.find("111")
    expect(bottle).to_not be_nil
  end

  it "should update an existing bottle" do
    barcello = create(:olcc_bottle)
    new_code = barcello.new_item_code
    old_code = barcello.old_item_code
    new_desc = "BARCELLO ANEJO"
    client = double("olcc-client")
    new_bottle = Dto::BottleData.new(
      category: "RUM", new_item_code: new_code, old_item_code: old_code,
      description: new_desc, size: barcello.size, proof: barcello.proof, age: "13yrs", bottle_price: 32.95
    )
    expect(client).to receive(:get_bottle_details).and_return(new_bottle)

    expect { LoadBottle.call(client, "RUM", new_code, old_code) }.to_not change { OlccStore.count }

    barcello.reload
    expect(barcello.description).to eq(new_desc)
  end
end
