require "test_helper"

class OlccInventoryTest < ActiveSupport::TestCase
  test "inventory count" do
    assert_equal 5, OlccInventory.count
  end

  test "inventory data" do
    b = olcc_bottles(:barcelo)
    s = olcc_stores(:bend3)
    i = olcc_inventories(:barcelo_bend)
    assert_equal 14, i.quantity
    assert_not_nil i.olcc_store
    assert_not_nil i.olcc_bottle
    assert_equal b.name, i.olcc_bottle.name
    assert_equal s.name, i.olcc_store.name
  end
end
