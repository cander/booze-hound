require "test_helper"
require "olcc_web/html_parser"

class OlccWeb::HtmlParserTest < ActiveSupport::TestCase
  test "inventory count" do
    inv = OlccWeb::HtmlParser.parseInventory(open("#{ActiveSupport::TestCase.fixture_path}/html/barcelo-detail.html"))
    assert_equal 9, inv.count

    dallas_store_num = "1016"  # can't use store_num from fixture data - should defined this somewhere
    dallas_inventory = inv.find {|i| i[:store_num] == dallas_store_num}
    assert_not_nil dallas_inventory
    assert_equal 6, dallas_inventory[:qty]
  end

end
