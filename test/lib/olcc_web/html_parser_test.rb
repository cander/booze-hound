require "test_helper"
require "olcc_web/html_parser"

class OlccWeb::HtmlParserTest < ActiveSupport::TestCase
  test "inventory for a bottle" do
    inv = OlccWeb::HtmlParser.parse_inventory(open_html_fixture("barcelo-detail.html"))
    assert_equal 9, inv.count

    dallas_store_num = "1016"  # can't use store_num from fixture data - should defined this somewhere
    dallas_inventory = inv.find { |i| i.store_num == dallas_store_num }
    assert_not_nil dallas_inventory
    assert_equal 6, dallas_inventory.quantity
  end

  test "quiet error in HTML" do
    assert_raises(RuntimeError) {
      OlccWeb::HtmlParser.parse_inventory(open_html_fixture("quiet-error.html"))
    }
  end
  test "stores in a city" do
    stores = OlccWeb::HtmlParser.parse_stores(open_html_fixture("bend-stores.html"))

    assert_equal 7, stores.count
    hiway97_store_num = "1069"
    # TODO: update for a DTO
    store = stores.find { |s| s.store_num == hiway97_store_num }
    assert_not_nil store
    assert_equal "BEND", store.location
    assert_equal "61153 S Highway 97", store.address
    assert_equal "97702", store.zip
    assert_equal "541-388-0692", store.telephone
    assert_equal "Mon-Thu 10-8; Fri-Sat 10-9; Sun 10-7", store.store_hours
  end
end
