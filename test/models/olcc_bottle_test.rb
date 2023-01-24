require "test_helper"

class OlccBottleTest < ActiveSupport::TestCase
  test "total bottle count" do
    assert_equal 4, OlccBottle.count
  end
end
