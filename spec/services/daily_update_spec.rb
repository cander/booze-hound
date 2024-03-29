require "rails_helper"
require_relative "../../test/test_helper"

RSpec.describe DailyUpdate do
  let(:client) { double nil }   # shouldn't touch OLCC anyway
  let(:writer) { StringIO.new }

  it "should call UpdateCategoryBottles twice and UpdateAllInventory once" do
    user = create(:user)
    user.add_category("RUM")
    user.add_category("GIN")
    user.add_category("TEQUILA")

    ucb = double "update-bottles"
    expect(ucb).to receive(:call).thrice
    allow(UpdateCategoryBottles).to receive(:new).and_return(ucb)

    uai = double "update-all-inventyory"
    expect(uai).to receive(:call)
    allow(UpdateAllInventory).to receive(:new).and_return(uai)

    DailyUpdate.call(client, writer)
  end
end
