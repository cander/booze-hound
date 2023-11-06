require "rails_helper"
require_relative "../../test/test_helper"

RSpec.describe LoadBottle do
  let(:client) { double("olcc-client") }

  context "creating new bottles" do
    let(:category) { "RUM" }
    let(:new_item_code) { "111" }
    let(:old_item_code) { "222B" }
    let(:new_bottle) {
      Dto::BottleData.new(
        category: category, new_item_code: new_item_code, old_item_code: old_item_code,
        description: "New Hooch", size: "666 ML", proof: 69, age: "13yrs", bottle_price: 69.69
      )
    }

    it "should insert a bottle" do
      expect(client).to receive(:get_bottle_details).with(category, new_item_code).and_return(new_bottle)

      expect { LoadBottle.call(client, category, new_item_code) }.to change { OlccBottle.count }.by 1

      bottle = OlccBottle.find(new_item_code)
      expect(bottle).to_not be_nil
    end

    it "should return nil if there is an error creating a bottle" do
      expect(client).to receive(:get_bottle_details).and_return(new_bottle)
      allow_any_instance_of(OlccBottle).to receive(:save).and_return(false)

      expect(LoadBottle.call(client, category, new_item_code)).to be_nil

      expect { OlccBottle.find(new_item_code) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context "updating existing bottles" do
    let(:barcelo) { create(:olcc_bottle) }
    let(:new_code) { barcelo.new_item_code }
    let(:old_code) { barcelo.old_item_code }
    let(:new_desc) { "BARCELLO ANEJO" }
    let(:new_bottle) {
      Dto::BottleData.new(
        category: "RUM", new_item_code: new_code, old_item_code: old_code,
        description: new_desc, size: barcelo.size, proof: barcelo.proof, age: "13yrs", bottle_price: 32.95
      )
    }

    it "should update an existing bottle" do
      expect(client).to receive(:get_bottle_details).and_return(new_bottle)

      expect { LoadBottle.call(client, "RUM", new_code) }.to_not change { OlccBottle.count }

      barcelo.reload
      expect(barcelo.description).to eq(new_desc)
    end

    it "should return nil if there is an error saving" do
      old_desc = barcelo.description
      expect(client).to receive(:get_bottle_details).and_return(new_bottle)
      allow_any_instance_of(OlccBottle).to receive(:update).and_return(false)

      expect(LoadBottle.call(client, "RUM", new_code)).to be_nil

      barcelo.reload
      expect(barcelo.description).to eq(old_desc)
    end
  end

  it "should return nil if web client fails" do
    expect(client).to receive(:get_bottle_details).and_raise(RuntimeError, "boom!")

    expect(LoadBottle.call(client, "RUM", "123")).to be_nil
  end
end
