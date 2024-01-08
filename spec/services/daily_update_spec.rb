require "rails_helper"
require_relative "../../test/test_helper"

RSpec.describe DailyUpdate do
  let(:client) { double nil }   # shouldn't touch OLCC anyway
  let(:writer) { StringIO.new }

  it "should call UpdateCategoryBottles twice and UpdateAllInventory once" do
    # TODO: create UserCategory records for users to control how many categories are updated
    ucb = double "update-bottles"
    expect(ucb).to receive(:call).twice
    allow(UpdateCategoryBottles).to receive(:new).and_return(ucb)

    uai = double "update-all-inventyory"
    expect(uai).to receive(:call)
    allow(UpdateAllInventory).to receive(:new).and_return(uai)

    DailyUpdate.call(client, writer)
  end
end
