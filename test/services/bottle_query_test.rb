require "test_helper"

class BottleQueryTest < ActiveSupport::TestCase
  test "count all bottles at a store" do
    store_num = olcc_stores(:independence).store_num
    found_bottles = BottleQuery.call(store_num, [])
    assert_equal 2, found_bottles.count
  end

  test "count only in-stock bottles at a store" do
    store_num = olcc_stores(:dallas).store_num
    found_bottles = BottleQuery.call(store_num, [])
    assert_equal 1, found_bottles.count
  end

  test "count in-staock bottles at multiple stores" do
    stores = [olcc_stores(:dallas).store_num]
    stores << olcc_stores(:independence).store_num
    found_bottles = BottleQuery.call(stores, [])
    assert_equal 3, found_bottles.count
  end
end
