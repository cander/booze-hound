# require 'olcc_web/html_parser'
require "faraday/follow_redirects"
require "faraday-cookie_jar"
module OlccWeb
  OLCC_ROOT = "http://www.oregonliquorsearch.com"

  class OlccWeb::Client
    attr_reader :logger

    def initialize(log, mock_conn = nil)
      @conn = mock_conn || Faraday.new("#{OLCC_ROOT}/servlet") do |builder|
        builder.response :follow_redirects
        builder.use :cookie_jar # important this is after follow_redirects
        builder.adapter Faraday.default_adapter
      end
      @last_category = ""
      @logger = log

      welcome
    end

    def select_category(cat)
      logger.info { "Selecting category: #{cat}" }
      opts = {view: "browsecategoriesallsubcategories", action: "select", category: cat}
      result = do_get("FrontController", opts)
      HtmlParser.check_quiet_error(result)
      @last_category = cat
      result
    end

    def get_item_inventory(cat, new_item_code, item_code)
      logger.info { "get_item_inventory category: #{cat}, new_item_code: #{new_item_code}, item_code: #{item_code}" }
      select_category(cat) if cat != @last_category
      # todo - set large window size on first query
      opts = {view: "browsesubcategories", action: "select", productRowNum: 79, columnParam: "Description"}
      inv_html = do_get("FrontController", opts.merge({newItemCode: new_item_code, itemCode: item_code}))
      HtmlParser.parse_inventory(inv_html)
    end

    def get_city_stores(city)
      city = city.upcase
      logger.info { "get_city_stores city: #{city}" }
      opts = {view: "browselocations", action: "select", city: city}
      store_html = do_get("FrontController", opts)
      HtmlParser.parse_stores(store_html)
    end

    def get_bottle_details(cat, new_item_code, item_code)
      logger.info { "get_bottle_details category: #{cat}, new_item_code: #{new_item_code}, item_code: #{item_code}" }
      # the HTTP call is the same as getting inventory
      select_category(cat) if cat != @last_category
      opts = {view: "browsesubcategories", action: "select", productRowNum: 79, columnParam: "Description"}
      inv_html = do_get("FrontController", opts.merge({newItemCode: new_item_code, itemCode: item_code}))
      # we just parse the output differently, ignoring inventory
      HtmlParser.parse_product_details(inv_html)
    end

    # pseudo private methods

    def welcome
      logger.debug "connecting to OLCC..."
      resp = @conn.get("WelcomeController")
      error "Failed to open WelcomeController - status: #{resp.status}" unless resp.success?
    end

    def do_get(servlet, opts)
      resp = @conn.get(servlet, opts)
      if resp.success?
        resp.body
      else
        error "HTTP error accessing #{servlet} - status code: #{resp.status}"
      end
    end

    def error(msg)
      logger.error msg
      raise msg
    end
  end
end
