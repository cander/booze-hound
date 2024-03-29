# Add an Exception class
require "faraday/follow_redirects"
require "faraday-cookie_jar"
module OlccWeb
  OLCC_ROOT = "http://www.oregonliquorsearch.com"

  class OlccWeb::Client
    attr_reader :logger

    SEARCH_LOCATION = "97361" # obviously, this works for me
    SEARCH_RADIUS = "30"

    def initialize(log, mock_conn = nil)
      @conn = mock_conn || Faraday.new("#{OLCC_ROOT}/servlet") do |builder|
        builder.response :follow_redirects
        builder.use :cookie_jar # important this is after follow_redirects
        builder.adapter Faraday.default_adapter
      end
      @last_category = ""
      @logger = log
      @default_page_size = true

      welcome
    end

    def select_category(cat)
      cat = cat.upcase
      logger.info { "Selecting category: #{cat}" }
      opts = {view: "browsecategoriesallsubcategories", action: "select", category: cat}
      cat_html = do_get("FrontController", opts)
      HtmlParser.check_quiet_error(cat_html)
      @last_category = cat

      cat_html
    end

    def get_category_bottles(cat)
      logger.info { "Getting bottles in category: #{cat}" }
      cat_html = select_category(cat)
      HtmlParser.parse_category_bottles(cat_html, cat)
    end

    def get_item_inventory(cat, new_item_code, item_code)
      logger.info { "get_item_inventory category: #{cat}, new_item_code: #{new_item_code}, item_code: #{item_code}" }
      # global search doesn't require selecting a category first
      opts = {view: "global", action: "search", chkDefault: "on", btnSearch: "Search",
              radiusSearchParam: SEARCH_RADIUS, locationSearchParam: SEARCH_LOCATION}
      inv_html = do_get("FrontController", opts.merge({productSearchParam: new_item_code}))
      rows, has_next = HtmlParser.parse_inventory(inv_html)
      if has_next && @default_page_size
        # set page size to 100 via pagechange. In the future this code should handle multiple
        # pages when the page size is 100.
        logger.info { "Setting page size to 100" }
        opts = {view: "productdetails", action: "pagechange", pageSize: 100, productRowNum: 1}
        inv_html = do_get("FrontController", opts.merge({productSearchParam: new_item_code}))
        rows, _ = HtmlParser.parse_inventory(inv_html) # ignore if this result is paginated
        @default_page_size = false
      end

      rows
    end

    def get_city_stores(city)
      city = city.upcase
      logger.info { "get_city_stores city: #{city}" }
      opts = {view: "browselocations", action: "select", city: city}
      store_html = do_get("FrontController", opts)
      HtmlParser.parse_stores(store_html)
    end

    def get_bottle_details(cat, new_item_code)
      logger.info { "get_bottle_details category: #{cat}, new_item_code: #{new_item_code}" }
      # the HTTP call can be the same as getting inventory, but this isn't
      # restricted by radius, and it requires selecting the category.
      select_category(cat) if cat != @last_category
      opts = {view: "browsesubcategories", action: "select", productRowNum: 79, columnParam: "Description"}
      inv_html = do_get("FrontController", opts.merge(newItemCode: new_item_code))
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
      raise ApiError, msg
    end
  end
end
