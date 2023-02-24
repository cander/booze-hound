# require 'olcc_web/html_parser'
require "faraday/follow_redirects"
require "faraday-cookie_jar"
module OlccWeb
  OLCC_ROOT = "http://www.oregonliquorsearch.com"

  class OlccWeb::Client
    attr_reader :conn  # for initial debug
    def initialize(mock_conn = nil)
      @conn = mock_conn || Faraday.new("#{OLCC_ROOT}/servlet") do |builder|
        builder.response :follow_redirects
        builder.use :cookie_jar # important this is after follow_redirects
        builder.adapter Faraday.default_adapter
      end

      welcome
    end

    def select_category(cat)
      opts = {view: "browsecategoriesallsubcategories", action: "select", category: cat}
      do_get("FrontController", opts)
    end

    def get_item_inventory(new_item_code, item_code)
      opts = {view: "browsesubcategories", action: "select", productRowNum: 79, columnParam: "Description"}
      inv_html = do_get("FrontController", opts.merge({newItemCode: new_item_code, itemCode: item_code}))
      HtmlParser.parseInventory(inv_html)
    end

    # pseudo private methods

    def welcome
      # Rails.logger.debug "connecting to OLCC..."
      resp = @conn.get("WelcomeController")
      raise "Failed to open WelcomeController - status: #{resp.status}" unless resp.success?
    end

    def do_get(servlet, opts)
      resp = @conn.get(servlet, opts)
      if resp.success?
        resp.body
      else
        raise "HTTP error accessing #{servlet} - status code: #{resp.status}"
      end
    end
  end
end
