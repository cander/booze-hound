require "test_helper"

class InventoryQueryTest < ActiveSupport::TestCase
  test "count all bottles at a store" do
    store_num = olcc_stores(:independence).store_num
    found_bottles = InventoryQuery.call(store_num, [])

    assert_equal 2, found_bottles.count
  end

  test "count only in-stock bottles at a store" do
    store_num = olcc_stores(:dallas).store_num
    found_bottles = InventoryQuery.call(store_num, [])

    assert_equal 1, found_bottles.count
  end

  test "count in-stock bottles at multiple stores" do
    stores = [olcc_stores(:dallas).store_num]
    stores << olcc_stores(:independence).store_num
    found_bottles = InventoryQuery.call(stores, [])

    assert_equal 3, found_bottles.count
  end

  test "query for one bottle at a store" do
    store_num = olcc_stores(:independence).store_num
    bottle = olcc_bottles(:pipe_dream)
    bottle_code = bottle.new_item_code
    found_bottles = InventoryQuery.call(store_num, [bottle_code])

    assert_equal 1, found_bottles.count
    assert_equal bottle.new_item_code, found_bottles.first.new_item_code
  end

  test "query for multiple bottles at a store" do
    store_num = olcc_stores(:independence).store_num
    bottle_codes = [olcc_bottles(:pipe_dream).new_item_code]
    bottle_codes << olcc_bottles(:barcelo).new_item_code
    bottle_codes << olcc_bottles(:black_tot).new_item_code  # not there

    found_bottles = InventoryQuery.call(store_num, [bottle_codes])

    assert_equal 2, found_bottles.count
  end
end
