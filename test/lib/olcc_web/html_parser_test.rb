require "test_helper"
require "olcc_web/html_parser"

class OlccWeb::HtmlParserTest < ActiveSupport::TestCase
  test "inventory for a bottle" do
    inv = OlccWeb::HtmlParser.parseInventory(open_html_fixture("barcelo-detail.html"))
    assert_equal 9, inv.count

    dallas_store_num = "1016"  # can't use store_num from fixture data - should defined this somewhere
    dallas_inventory = inv.find { |i| i[:store_num] == dallas_store_num }
    assert_not_nil dallas_inventory
    assert_equal 6, dallas_inventory[:qty]
  end

  test "quiet error in HTML" do
    assert_raises(RuntimeError) {
      OlccWeb::HtmlParser.parseInventory(open_html_fixture("quiet-error.html"))
    }
  end
end
