# Parse HTML from the OLCC's web site. In theory, this could be very
# brittle. In reality, it doesn't look like it's changed in over 10 years.
require "nokogiri"

module OlccWeb
  class HtmlParser
    def self.parseInventory(inventory_page_html)
      check_quiet_error(inventory_page_html)
      doc = Nokogiri::HTML(inventory_page_html)
      result = []
      new_item_code = doc.css("td.search-box").first.child["value"] # could assert this value against a param

      doc.css("tr.row").each { |row| result << parseInventoryRow(new_item_code, row) }
      doc.css("tr.alt-row").each { |row| result << parseInventoryRow(new_item_code, row) }

      result
    end

    def self.parseInventoryRow(new_item_code, row)
      store_num = row.css("td.store-no").text.strip
      quantity = row.css("td.qty").text.strip.to_i
      InventoryData.new(new_item_code, store_num, quantity)
    end

    def self.check_quiet_error(html)
      if /An Error Has Occurred/.match?(html)
        raise "OLCC error page encountered"
      end
    end
  end
end
