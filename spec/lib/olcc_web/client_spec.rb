require "rails_helper"

RSpec.describe OlccWeb::Client do
  # Faraday test adapter
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:conn) { Faraday.new { |b| b.adapter(:test, stubs) } }
  let(:client) { described_class.new(conn) }

  after do
    Faraday.default_connection = nil
  end
  it "calls welcome with a stub" do
    stubs.get("/WelcomeController") { [200, {}, "hello"] }

    client.inspect
    stubs.verify_stubbed_calls
  end

  it "gets the rum categories" do
    stubs.get("/WelcomeController") { [200, {}, "hello"] }
    stubs.get("/FrontController") { [200, {}, "all the rums"] }

    puts client.select_category("RUM")
    stubs.verify_stubbed_calls
  end
end
