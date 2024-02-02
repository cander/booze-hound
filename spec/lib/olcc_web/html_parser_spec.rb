RSpec.describe OlccWeb::HtmlParser do
  let(:quiet_error) { open_html_fixture("quiet-error.html") }

  describe "parse_inventory" do
    it "parses the inventory for a bottle at multiple stores" do
      inv, has_next = OlccWeb::HtmlParser.parse_inventory(open_html_fixture("barcelo-detail.html"))
      expect(inv.count).to eq(9)
      expect(has_next).to be false

      dallas_store_num = "1016"
      dallas_inventory = inv.find { |i| i.store_num == dallas_store_num }
      expect(dallas_inventory).to_not be_nil
      expect(dallas_inventory.quantity).to eq(6)
    end

    it "parses the inventory for a bottle at a single store" do
      inv, has_next = OlccWeb::HtmlParser.parse_inventory(open_html_fixture("single-store-inventory.html"))

      expect(inv.count).to eq(1)
      expect(has_next).to be false

      store_inv = inv.first
      expect(store_inv.store_num).to eq("1198")
      expect(store_inv.new_item_code).to eq("99900885175")
      expect(store_inv.quantity).to eq(69)
    end

    it "parses no inventory when not available" do
      inv, has_next = OlccWeb::HtmlParser.parse_inventory(open_html_fixture("zero-store-inventory.html"))
      expect(inv.count).to eq(0)
      expect(has_next).to be false
    end

    it "recognizes a Next link in pages results " do
      inv, has_next = OlccWeb::HtmlParser.parse_inventory(open_html_fixture("inventory-with-next.html"))
      expect(has_next).to be true
      expect(inv.count).to eq(10)
    end

    it "raises an error for a quiet error in the HTML" do
      expect { OlccWeb::HtmlParser.parse_inventory(quiet_error) }.to raise_error(OlccWeb::ApiError)
    end
  end

  describe "parse_stores" do
    it "parses the stores in a city" do
      stores = OlccWeb::HtmlParser.parse_stores(open_html_fixture("bend-stores.html"))

      expect(stores.count).to eq(7)
      hiway97_store_num = "1069"
      store = stores.find { |s| s.store_num == hiway97_store_num }
      expect(store).to_not be_nil
      expect(store.location).to eq("BEND")
      expect(store.address).to eq("61153 S Highway 97")
      expect(store.zip).to eq("97702")
      expect(store.telephone).to eq("541-388-0692")
      expect(store.store_hours).to eq("Mon-Thu 10-8; Fri-Sat 10-9; Sun 10-7")
    end

    it "raises an error for a quiet error in the HTML" do
      expect { OlccWeb::HtmlParser.parse_stores(quiet_error) }.to raise_error(OlccWeb::ApiError)
    end
  end

  describe "parse_product_details" do
    describe "unpack_description " do
      [
        ["Barcelo", "99900592775", "5927B", "BARCELO IMPERIAL",
          "\r\n\t\t\t\tItem\r\n\t\t\t99900592775(5927B):\r\n\t\tBARCELO IMPERIAL\r\n\t"],
        ["1792", "99900388475", "3884B", "1792 SINGLE BARREL BOURBON",
          "t\t\t\t\tItem\r\n\t\t\t\t\t\t\t\t99900388475(3884B):\r\n\t\t\t\t\t\t\t\t1792 SINGLE BARREL BOURBON\r\n\t\t"],
        ["Woodford derby", "99900784610", "7846A", "WOODFORD RES. DERBY 10",
          "t\t\t\t\tItem\r\n\t\t\t\t\t\t\t\t99900784610(7846A):\r\n\t\t\t\t\t\t\t\tWOODFORD RES. DERBY 10\r\n\t\t"],
        ["Hayman's", "99900885175", "8851B", "HAYMAN'S OLD TOM GIN",
          "t\t\t\t\tItem\r\n\t\t\t\t\t\t\t\t99900885175(8851B):\r\n\t\t\t\t\t\t\t\tHAYMAN'S OLD TOM GIN\r\n\t\t"],
        ["Kentucky Owl", "99900531075", "5310B", "KENTUCKY OWL BATCH #11",
          "\tItem\r\n\t\t\t\t\t\t\t\t99900531075(5310B):\r\n\t\t\t\t\t\t\t\tKENTUCKY OWL BATCH #11\r\n\t\t\t"],
        ["Ancient Age", "99900197975", "1979B", "ANCIENT ANCIENT AGE 10 *",
          "\t\t\t\tItem\r\n\t\t\t\t\t\t\t\t99900197975(1979B):\r\n\t\t\t\t\t\t\t\tANCIENT ANCIENT AGE 10 *\r\n\t\t"],
        ["Balcones", "99900919875", "9198B", "BALCONES SINGLE BARREL S/M",
          "\t\t\t\tItem\r\n\t\t\t\t\t\t\t\t99900919875(9198B):\r\n\t\t\t\t\t\t\t\tBALCONES SINGLE BARREL S/M\r\n\t\t"],
        ["Irwin", "99900075305", "0753F", "C.W. IRWIN STRAIGHT BOURBO",
          "\t\t\t\tItem\r\n\t\t\t\t\t\t\t\t99900075305(0753F):\r\n\t\t\t\t\t\t\t\tC.W. IRWIN STRAIGHT BOURBO\r\n\t\t"]

      ].each do |product, new_item_code, old_item_code, description, text|
        describe "parses #{product} text from HTML" do
          it {
            details = OlccWeb::HtmlParser.unpack_description(text)

            expect(details).to_not be_nil
            expect(details[:new_item_code]).to eq(new_item_code)
            expect(details[:old_item_code]).to eq(old_item_code)
            expect(details[:description]).to eq(description)
          }
        end
      end
    end

    it "returns nil if it can't parse" do
      details = OlccWeb::HtmlParser.unpack_description("spanish inquisition")

      expect(details).to be_nil
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
      it "parses LITER w/o digits" do
        text = "\t\tSize:\r\n\t\tLITER\r\n\t\t\tCase Price:\r\n\t\t$269.70\r\n\t\t"
        size_hash = OlccWeb::HtmlParser.unpack_size(text)

        expect(size_hash).to_not be_nil
        expect(size_hash[:size]).to eq("LITER")
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
      expect(details.description).to eq("BARCELO IMPERIAL")
      expect(details.size).to eq("750 ML")
      expect(details.proof).to eq(80.0)
      expect(details.category).to eq("RUM")
      expect(details.age).to eq("")
      expect(details.bottle_price).to eq(35.95)
    end
    it "raises an error for a quiet error in the HTML" do
      expect { OlccWeb::HtmlParser.parse_product_details(quiet_error) }.to raise_error(OlccWeb::ApiError)
    end
  end
  describe "parse_category_bottles" do
    it "parses the bottles in a category" do
      bottles = OlccWeb::HtmlParser.parse_category_bottles(open_html_fixture("all-cachaca-bottles.html"), "CACHACA")

      expect(bottles.count).to eq(18)
      avua = bottles.first
      expect(avua.new_item_code).to eq("99900279575")
      expect(avua.old_item_code).to eq("2795B")
      expect(avua.description).to eq("AVUA AMBURANA")
      expect(avua.size).to eq("750 ML")
      expect(avua.proof).to eq("80.0")
      expect(avua.age).to eq("")
      expect(avua.bottle_price).to eq("49.35")
      expect(avua.category).to eq("CACHACA")
    end
  end
end
