require "test_helper"

class OlccStoreTest < ActiveSupport::TestCase
  test "store count" do
    assert_equal 3, OlccStore.count
  end

  test "store attributes" do
    s = olcc_stores(:independence)
    assert_equal s.name, 'Independence'
  end
end
