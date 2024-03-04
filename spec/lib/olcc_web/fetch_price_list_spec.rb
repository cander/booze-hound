RSpec.describe OlccWeb::FetchPriceList do
  let(:quiet_error) { open_html_fixture("small-bad-header.csv") }

  describe "get_clean_header" do
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
