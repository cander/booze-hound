require "test_helper"

class InventoryQueryTest < ActiveSupport::TestCase
  test "count all bottles at a store" do
    store = olcc_stores(:independence)
    found_bottles = InventoryQuery.call(store, [])

    assert_equal 2, found_bottles.count
  end

  test "count only in-stock bottles at a store" do
    store = olcc_stores(:dallas)
    found_bottles = InventoryQuery.call(store, [])

    assert_equal 1, found_bottles.count
  end

  test "count in-stock bottles at multiple stores" do
    stores = olcc_stores(:dallas, :independence)
    found_bottles = InventoryQuery.call(stores, [])

    assert_equal 3, found_bottles.count
  end

  test "query for one bottle at a store" do
    store_num = olcc_stores(:independence).store_num
    bottle = olcc_bottles(:pipe_dream)
    found_bottles = InventoryQuery.call(store_num, [bottle])

    assert_equal 1, found_bottles.count
    assert_equal bottle.new_item_code, found_bottles.first.new_item_code
  end

  test "query for multiple bottles at a store" do
    store_num = olcc_stores(:independence).store_num
    bottle_codes = olcc_bottles(:pipe_dream, :barcelo, :black_tot)  # black_tot not there

    found_bottles = InventoryQuery.call(store_num, [bottle_codes])

    assert_equal 2, found_bottles.count
  end
end
