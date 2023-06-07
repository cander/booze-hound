# Parse HTML from the OLCC's web site. In theory, this could be very
# brittle. In reality, it doesn't look like it's changed in over 10 years.
# TODO idea - change from static methods to member methods and have an
# instance variable holding the Nokogiri doc?
require "nokogiri"

module OlccWeb
  class HtmlParser
    def self.parse_inventory(inventory_page_html)
      check_quiet_error(inventory_page_html)
      doc = Nokogiri::HTML(inventory_page_html)
      result = []
      new_item_code = doc.css("td.search-box").first.child["value"] # could assert this value against a param

      all_rows = merge_table_rows(doc.css("tr.alt-row"), doc.css("tr.row"))
      all_rows.each { |row| result << parse_inventory_row(new_item_code, row) }

      result
    end

    def self.parse_stores(store_page_html)
      check_quiet_error(store_page_html)
      doc = Nokogiri::HTML(store_page_html)
      result = []
      doc.css("tr.row").each { |row| result << parse_store_row(row) }
      doc.css("tr.alt-row").each { |row| result << parse_store_row(row) }

      result
    end

    def self.parse_product_details(inventory_page_html)
      check_quiet_error(inventory_page_html)
      doc = Nokogiri::HTML(inventory_page_html)
      desc_table = doc.css("table")[2].css("table")  # 'product-details' doesn't work

      desc = unpack_description(desc_table.css("tr")[1].text)
      # NB: can improve the parsing of cat_age, price, and proof by accessing td elements
      cat_age = unpack_category_age(desc_table.css("tr")[2].text)
      size = unpack_size(desc_table.css("tr")[3].text)
      proof_price = unpack_proof_price(desc_table.css("tr")[4].text)

      if desc && cat_age && size && proof_price
        opts = desc.merge(cat_age).merge(size).merge(proof_price)
        Dto::BottleData.new(**opts)
      else
        raise "Missing bottle data - desc: #{desc}, cat_age: #{cat_age}, size: #{size}, proof_price: #{proof_price}"
      end
    end

    def self.parse_category_bottles(cat_html, cat)
      check_quiet_error(cat_html)
      doc = Nokogiri::HTML(cat_html)

      result = []
      all_rows = merge_table_rows(doc.css("tr.alt-row"), doc.css("tr.row"))
      all_rows.each { |row| result << parse_bottle_row(row, cat) }

      result
    end

    # pseudo private methods

    def self.parse_inventory_row(new_item_code, row)
      store_num = row.css("td.store-no").text.strip
      quantity = row.css("td.qty").text.strip.to_i
      Dto::InventoryData.new(new_item_code, store_num, quantity)
    end

    def self.parse_store_row(row)
      # Store-No	Location	Address	Zip	Telephone	Store-Hours
      values = row.css("td").map { |c| c.text.strip }
      # NB: counting on the order of the columns/values match the order that
      # we declared the attributes in the DTO. That's why we have a test.
      Dto::StoreData.new(*values)
    end

    def self.unpack_description(desc)
      # \r\n\t\t\t\tItem\r\n\t\t\t99900592775(5927B):\r\n\t\tBARCELO IMPERIAL\r\n\t
      # NB: assuming the old item codes always end with a capital letter
      if desc =~ /Item\s+(\d+)\((\d+[A-Z])\):\s+(\w.*\S)\s+$/
        data = Regexp.last_match
        {new_item_code: data[1], old_item_code: data[2], description: data[3].strip}
      end
      # else returning nil
    end

    def self.unpack_category_age(text)
      # t\t\tCategory:\r\n\t\t\tRUM|GOLD \r\n\t\t\tAge: 8 yrs\r\n\t\t\t\t \r\n\t\
      text.strip!
      if text =~ /Category:\s+(\w[^|]+)\|/  # up to the first pipe char
        cat = Regexp.last_match[1]
      else
        return nil
      end

      if text =~ /Age:\s+(\d+.+)$/
        age = Regexp.last_match[1]
      elsif /Age:$/.match?(text)
        age = ""
      else
        return nil
      end

      {category: cat, age: age}
    end

    def self.unpack_size(text)
      # \t\tSize:\r\n\t\t750 ML\r\n\t\t\tCase Price:\r\n\t\t$269.70\r\n\t\t
      size = if text =~ /Size:\s+([\d.]+\s+[A-Z]+)+/
        Regexp.last_match[1]
      elsif /Size:\s+LITER/.match?(text)
        "LITER"
      else
        ""  # maybe this is an error?
      end
      {size: size}
    end

    def self.unpack_proof_price(text)
      # \r\n\t\tProof:\r\n\t\t\t98.6\r\n\t\tBottle Price:\r\n\t\t$44.95\r\n\t\t"
      text.strip!
      proof = if text =~ /Proof:\s+(\d[0-9.]+)/
        Regexp.last_match[1].to_f
      else
        0.0 # maybe this is an error?
      end

      price = if text =~ /Bottle Price:\s+\$(\d[0-9.]+)/
        Regexp.last_match[1].to_f
      else
        0.0 # maybe this is an error?
      end

      {proof: proof, bottle_price: price}
    end

    def self.parse_bottle_row(row, cat)
      data = row.css("td")
      attrs = {
        new_item_code: data[0].text.strip,
        old_item_code: data[1].text.strip,
        description: data[2].text.strip,
        size: data[3].text.strip,
        proof: data[4].text.strip,
        age: data[5].text.strip,
        bottle_price: data[7].text.strip.sub("$", ""),
        category: cat
      }

      Dto::BottleData.new(**attrs)
    end

    def self.check_quiet_error(html)
      if /An Error Has Occurred/.match?(html)
        raise "OLCC error page encountered"
      end
    end

    # merge two lists of alternating table rows
    def self.merge_table_rows(a1, a2)
      a2, a1 = a1, a2 if a2.size > a1.size
      result = []
      a2.size.times do |idx|
        result << a1[idx]
        result << a2[idx]
      end
      result << a1.last if a1.size == (a2.size + 1)

      result
    end
  end
end
