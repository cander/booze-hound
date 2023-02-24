require "rails_helper"
# require "test_helper"

RSpec.describe OlccWeb::Client do
  # Faraday test adapter
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:conn) { Faraday.new { |b| b.adapter(:test, stubs) } }
  let(:client) { described_class.new(conn) }

  after do
    Faraday.default_connection = nil
  end
  it "calls welcome when we create a client" do
    stubs.get("/WelcomeController") { [200, {}, "hello"] }

    client.inspect
    stubs.verify_stubbed_calls
  end

  it "gets the rum category" do
    stubs.get("/WelcomeController") { [200, {}, "hello"] }
    stubs.get("/FrontController") { [200, {}, "all the rums"] }

    puts client.select_category("RUM")
    stubs.verify_stubbed_calls
  end

  it "gets a single bottle inventory" do
    stubs.get("/WelcomeController") { [200, {}, "hello"] }
    inv_html = open_html_fixture("barcelo-detail.html")
    stubs.get("/FrontController") { [200, {}, inv_html] }

    puts client.get_item_inventory("99900592775", "5927B")

    # dallas_store_num = "1016"  # can't use store_num from fixture data - should defined this somewhere
    # dallas_inventory = inv.find { |i| i[:store_num] == dallas_store_num }
    # assert_not_nil dallas_inventory
    # assert_equal 6, dallas_inventory[:qty]

    stubs.verify_stubbed_calls
  end
end
