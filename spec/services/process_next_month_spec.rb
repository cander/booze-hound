require "rails_helper"
require_relative "../../test/test_helper"

RSpec.describe ProcessNextMonth do
  let(:fetcher) { double("fetcher") }
  let(:bottle) { create(:olcc_bottle) }

  def dto(code, price)
    Dto::BottleData.new(
      new_item_code: code,
      old_item_code: "old-7",
      description: "old description",
      size: "750ML",
      proof: 100,
      age: "NAS",
      category: "UNKNOWN",
      bottle_price: price
    )
  end

  it "should update the next month price for a bottle" do
    new_price = bottle.bottle_price + 10
    next_bottle = dto(bottle.new_item_code, new_price)
    expect(fetcher).to receive(:get_bottles).and_return([next_bottle])
    ProcessNextMonth.call(fetcher)

    bottle.reload
    expect(bottle.next_bottle_price).to eq(new_price)
  end
end
