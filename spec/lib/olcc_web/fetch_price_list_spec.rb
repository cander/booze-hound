RSpec.describe OlccWeb::FetchPriceList do
  describe "#get_bottles" do
    # Faraday test adapter
    let(:stubs) { Faraday::Adapter::Test::Stubs.new }
    let(:conn) { Faraday.new { |b| b.adapter(:test, stubs) } }
    let(:client) { described_class.new(Rails.logger, conn) }
    let(:next_month) { OlccWeb::FetchPriceList::NEXT_MONTH }
    let(:small_prices) { open_html_fixture("small-bad-header.csv") }

    it "should parse a CSV file of prices" do
      stubs.get(next_month) { [200, {}, small_prices] }
      fetch = described_class.new(Rails.logger, next_month, conn)

      bottles = fetch.get_bottles

      expect(bottles.size).to eq(9)
      stubs.verify_stubbed_calls
      evan = bottles.last
      expect(evan.new_item_code).to eq("99900013617")
      expect(evan.bottle_price).to eq(31.95)
    end
  end

  describe "#get_clean_header" do
    # this is testing internal stuff, but it is important given that OLCC
    # generates invalid CSVs.
    it "collapses three header lines into one" do
      bad_header = <<~EOF
        "Item Code","New Item Code","Item Status","Description","Size","Age","Proof","Bottles
        
        Per Case","Unit Price","Effective Date"
      EOF
      sio = StringIO.new(bad_header)
      fetch = OlccWeb::FetchPriceList.get_next_month(nil)
      header = fetch.get_clean_header(sio)

      expect(header).to eq('"Item Code","New Item Code","Item Status","Description","Size","Age","Proof","Bottles Per Case","Unit Price","Effective Date"')
    end
  end
end
