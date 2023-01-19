require "test_helper"

class OlccStoreTest < ActiveSupport::TestCase
  test "store count" do
    assert_equal 2, OlccStore.count
  end

  test "store attributes" do
    s = OlccStore.first
    assert_equal s.name, 'Independence'
  end
end
