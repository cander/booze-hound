require "test_helper"

class OlccInventoryTest < ActiveSupport::TestCase
  test "inventory count" do
    assert_equal 1, OlccInventory.count
  end

  test "inventory data" do
    i = OlccInventory.first
    assert_equal 7, i.quantity
    assert_not_nil i.olcc_store
    assert_not_nil i.olcc_bottle
    assert_equal 'REDWOOD EMPIRE PIPE DREAM', i.olcc_bottle.name
    assert_equal 'Dallas', i.olcc_store.name
  end
end
