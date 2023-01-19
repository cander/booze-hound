require "test_helper"

class OlccBottleTest < ActiveSupport::TestCase
  test "bottle count" do
    assert_equal 2, OlccBottle.count
  end
end
