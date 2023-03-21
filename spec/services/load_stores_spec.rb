require "rails_helper"
require_relative "../../test/test_helper"

RSpec.describe LoadStores do
  it "should insert a new record" do
    client = double("olcc-client")
    new_store = [Dto::StoreData.new(
      store_num: "1273", location: "BEND", address: "740 NE Third St Ste 5", zip: "97701", telephone: "541-797-0028", store_hours: "Mon-Sat 10-8; Sun 11-7"
    )]
    expect(client).to receive(:get_city_stores).and_return(new_store)

    LoadStores.call(client, "bend")

    bend = OlccStore.find("1273")
    expect(bend).to_not be_nil
  end

  def load_store_fixtures
    # NB: manually loading fixtures is probably asking for problems
    require "active_record/fixtures"
    fix_set = ActiveRecord::FixtureSet.create_fixtures(Rails.root.join("test", "fixtures"), "olcc_stores")
    fix_set.first.fixtures # return the fixtures we just created
  end

  it "should update an existing record" do
    fixtures = load_store_fixtures
    store_num = fixtures["dallas"]["store_num"]
    puts "Before dallas hours: #{fixtures["dallas"]["store_hours"]}"
    store_hours = "Mon-Sat 10-8"
    client = double("olcc-client")
    new_store = [Dto::StoreData.new(
      store_num: store_num, location: "DALLAS", address: "170 W Ellendale Ste 105", zip: "97338", telephone: "503-623-9668", store_hours: store_hours
    )]
    expect(client).to receive(:get_city_stores).and_return(new_store)

    LoadStores.call(client, "dallas")

    dallas = OlccStore.find(store_num)
    puts "updated dallas: #{dallas.inspect}"
    expect(dallas).to_not be_nil
    expect(dallas.store_hours).to eq(store_hours)
  end
end
