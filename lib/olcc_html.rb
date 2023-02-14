# Parse HTML from the OLCC's web site. In theory, this could be very
# brittle. In reality, it doesn't look like it's changed in over 10 years.
require 'nokogiri'

class OlccHtml
  def self.parseInventory(inventory_page_html)
    doc = Nokogiri::HTML(inventory_page_html)
    result = []
    new_item_code = doc.css("td.search-box").first.child['value'] # could assert this value against a param

    for row in doc.css("tr.row") do  result << self.parseInventoryRow(new_item_code, row)  end
    for row in doc.css("tr.alt-row") do  result << self.parseInventoryRow(new_item_code, row)  end

    result
  end

  def self.parseInventoryRow(new_item_code, row)
      store_num = row.css("td.store-no").text.strip
      qty = row.css("td.qty").text.strip.to_i
      {new_item_code: new_item_code, store_num: store_num, qty: qty}
  end
end
