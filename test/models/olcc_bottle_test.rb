require "test_helper"

class OlccBottleTest < ActiveSupport::TestCase
  test "total bottle count" do
    assert_equal 5, OlccBottle.count
  end

  test "followed bottle count" do
    assert_equal 4, OlccBottle.followed_bottles.count
  end
end
