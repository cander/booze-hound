
require "test_helper"

class StoreQueryTest < ActiveSupport::TestCase
  test "fetch all stores with bottle" do
    bottle = olcc_bottles(:pipe_dream)
    user_stores = olcc_stores(:independence, :bend3)  # bottle not in bend3
    found_stores = StoreQuery.call(bottle, user_stores)

    assert_equal 1, found_stores.count
  end
end
