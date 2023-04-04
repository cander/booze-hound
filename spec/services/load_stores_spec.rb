require "rails_helper"
require_relative "../../test/test_helper"

RSpec.describe LoadStores do
  it "should insert a new record" do
    client = double("olcc-client")
    new_store = [Dto::StoreData.new(
      store_num: "1273", location: "BEND", address: "740 NE Third St Ste 5", zip: "97701", telephone: "541-797-0028", store_hours: "Mon-Sat 10-8; Sun 11-7"
    )]
    expect(client).to receive(:get_city_stores).and_return(new_store)

    expect { LoadStores.call(client, "bend") }.to change { OlccStore.count }.by 1

    bend = OlccStore.find("1273")
    expect(bend).to_not be_nil
    expect(bend.name).to eq("Bend")
  end

  it "should update an existing record" do
    dallas = create(:olcc_store)
    store_num = dallas.store_num
    store_hours = "Mon-Sat 10-8"
    client = double("olcc-client")
    new_store = [Dto::StoreData.new(
      store_num: store_num, location: "DALLAS", address: "170 W Ellendale Ste 105", zip: "97338", telephone: "503-623-9668", store_hours: store_hours
    )]
    expect(client).to receive(:get_city_stores).and_return(new_store)

    expect { LoadStores.call(client, "dallas") }.to_not change { OlccStore.count }

    dallas.reload
    expect(dallas.store_hours).to eq(store_hours)
    expect(dallas.name).to eq("Dallas")
  end

  context "when there are multiple stores in a location" do
    it "add the store number to the name" do
      client = double("olcc-client")
      new_store = [
        Dto::StoreData.new(store_num: "1273", location: "BEND", address: "740 NE Third St Ste 5", zip: "97701",
          telephone: "541-797-0028", store_hours: "Mon-Sat 10-8; Sun 11-7"),
        Dto::StoreData.new(store_num: "1069", location: "BEND", address: "61153 S Highway 97", zip: "97702",
          telephone: "541-388-0692", store_hours: "Mon-Thu 10-8; Fri-Sat 10-9; Sun 10-7")
      ]
      expect(client).to receive(:get_city_stores).and_return(new_store)

      expect { LoadStores.call(client, "bend") }.to change { OlccStore.count }.by 2

      expect(OlccStore.find("1273").name).to eq("Bend - 1273")
      expect(OlccStore.find("1069").name).to eq("Bend - 1069")
    end
  end
end
