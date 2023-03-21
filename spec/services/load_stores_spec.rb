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
  end
end
