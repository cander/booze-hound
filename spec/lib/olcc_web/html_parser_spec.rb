RSpec.describe OlccWeb::HtmlParser do
  describe "unpack_description" do
    it "parses a valid Barcelo description line" do
      desc = "\r\n\t\t\t\tItem\r\n\t\t\t99900592775(5927B):\r\n\t\tBARCELO IMPERIAL\r\n\t"
      details = OlccWeb::HtmlParser.unpack_description(desc)

      expect(details).to_not be_nil
      expect(details[:new_item_code]).to eq("99900592775")
      expect(details[:old_item_code]).to eq("5927B")
      expect(details[:name]).to eq("BARCELO IMPERIAL")
    end

    it "parses 1792 description line" do
      # pending
      desc = "t\t\t\t\tItem\r\n\t\t\t\t\t\t\t\t99900388475(3884B):\r\n\t\t\t\t\t\t\t\t1792 SINGLE BARREL BOURBON\r\n\t\t"
      details = OlccWeb::HtmlParser.unpack_description(desc)

      expect(details).to_not be_nil
      expect(details[:new_item_code]).to eq("99900388475")
      expect(details[:old_item_code]).to eq("3884B")
      expect(details[:name]).to eq("1792 SINGLE BARREL BOURBON")
    end

    it "returns nil if it can't parse" do
      details = OlccWeb::HtmlParser.unpack_description("spanish inquisition")

      expect(details).to be_nil
    end
  end

  describe "unpack_category_age" do
    it "parses category with an age" do
      text = "\t\tCategory:\r\n\t\tDOMESTIC WHISKEY|STRAIGHT|BOURBON / TN WHISKEY\r\n\t\t\tAge:\r\n\t\t\t8 yrs\r\n\t\t"
      cat_age = OlccWeb::HtmlParser.unpack_category_age(text)

      expect(cat_age).to_not be_nil
      expect(cat_age[:category]).to eq("DOMESTIC WHISKEY")
      expect(cat_age[:age]).to eq("8 yrs")
    end
    it "parses category without an age" do
      text = "\t\tCategory:\r\n\t\tRUM|GOLD \r\n\t\tAge:\r\n\t\t \r\n\t"
      cat_age = OlccWeb::HtmlParser.unpack_category_age(text)

      expect(cat_age).to_not be_nil
      expect(cat_age[:category]).to eq("RUM")
      expect(cat_age[:age]).to eq("")
    end

    it "returns nil if it can't parse" do
      details = OlccWeb::HtmlParser.unpack_category_age("spanish inquisition")

      expect(details).to be_nil
    end
  end

  describe "unpack_size" do
    it "parses a size in ML" do
      text = "\t\tSize:\r\n\t\t750 ML\r\n\t\t\tCase Price:\r\n\t\t$269.70\r\n\t\t"
      size_hash = OlccWeb::HtmlParser.unpack_size(text)

      expect(size_hash).to_not be_nil
      expect(size_hash[:size]).to eq("750 ML")
    end
    it "parses a size in L" do
      text = "\t\tSize:\r\n\t\t1.75 L\r\n\t\t\tCase Price:\r\n\t\t$269.70\r\n\t\t"
      size_hash = OlccWeb::HtmlParser.unpack_size(text)

      expect(size_hash).to_not be_nil
      expect(size_hash[:size]).to eq("1.75 L")
    end
  end

  describe "unpack_proof_price" do
    it "extracts the required proof and price" do
      text = "\r\n\t\tProof:\r\n\t\t\t98.6\r\n\t\tBottle Price:\r\n\t\t$44.95\r\n\t\t"
      proof_price = OlccWeb::HtmlParser.unpack_proof_price(text)

      expect(proof_price).to_not be_nil
      expect(proof_price[:proof]).to eq(98.6)
      expect(proof_price[:bottle_price]).to eq(44.95)
    end
  end

  it "parses the product details" do
    details = OlccWeb::HtmlParser.parse_product_details(open_html_fixture("barcelo-detail.html"))

    expect(details).to_not be_nil
    expect(details.new_item_code).to eq("99900592775")
    expect(details.old_item_code).to eq("5927B")
    expect(details.name).to eq("BARCELO IMPERIAL")
    expect(details.size).to eq("750 ML")
    expect(details.proof).to eq(80.0)
    expect(details.category).to eq("RUM")
    expect(details.age).to eq("")
    expect(details.bottle_price).to eq(35.95)
  end
end
