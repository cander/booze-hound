require "minitest/autorun"
require "rspec/mocks/minitest_integration" # could use minitest mocks
require "test_helper"

class UpdateInventoryTest < ActiveSupport::TestCase
  def rum
    olcc_bottles(:barcelo)
  end

  def store_num(sym_name)
    olcc_stores(sym_name).store_num
  end

  test "update inventory of an existing bottle in a store" do
    indy_id = store_num(:independence)
    client = double("olcc-client")
    new_inv = [InventoryData.new(new_item_code: rum.new_item_code, store_num: indy_id, quantity: 5)]
    expect(client).to receive(:get_item_inventory).and_return(new_inv)

    UpdateInventory.call(client, rum)

    new_inv_count = InventoryQuery.call(indy_id, [rum]).first.quantity
    assert_equal 5, new_inv_count
  end

  test "insert inventory of a new bottle in a store" do
    dallas_id = store_num(:dallas)
    client = double("olcc-client")
    new_inv = [InventoryData.new(new_item_code: rum.new_item_code, store_num: dallas_id, quantity: 5)]
    expect(client).to receive(:get_item_inventory).and_return(new_inv)

    UpdateInventory.call(client, rum)

    new_inv_count = InventoryQuery.call(dallas_id, [rum]).first.quantity
    assert_equal 5, new_inv_count
  end

  test "zero the quantity for stores missing from inventory" do
    client = double("olcc-client")
    expect(client).to receive(:get_item_inventory).and_return([])

    UpdateInventory.call(client, rum)

    new_inv = OlccInventory.where(new_item_code: rum)
    new_inv.each { |inv| assert_equal 0, inv.quantity }
  end
end
