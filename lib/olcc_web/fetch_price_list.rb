require "stringio"
require "csv"
require "faraday"

module OlccWeb
  class FetchPriceList
    CSV_ROOT = "https://www.olcc.state.or.us/pdfs"
    CURRENT_MONTH = "NumericPriceListCurrentMonth.csv"
    NEXT_MONTH = "NumericPriceListNextMonth.csv"

    def self.get_next_month(log)
      FetchPriceList.new(log, NEXT_MONTH)
    end

    def self.get_current(log)
      FetchPriceList.new(log, CURRENT_MONTH)
    end

    def initialize(log, page, mock_conn = nil)
      @logger = log
      @page = page
      @conn = mock_conn || Faraday.new(CSV_ROOT)
    end

    # TODO: how can we capture the effecitve date (month) from the first CSV row?

    # return array of DTOs - future: take a block to process one row at a time
    def get_bottles
      body = do_get
      rows = get_rows(body)
      result = []
      rows.each do |row|
        puts row["Description"]
        result << Dto::BottleData.new(
          new_item_code: row["New Item Code"],
          old_item_code: row["Item Code"],
          description: row["Description"],
          size: row["Size"],
          proof: row["Proof"],
          age: row["Age"],
          category: "UNKNOWN",
          bottle_price: row["Unit Price"]
        )
      end

      result
    end

    def get_rows(body)
      sio = StringIO.new(body)
      header_line = get_clean_header(sio)
      header_arry = CSV.parse(header_line).first

      CSV.new(sio, headers: header_arry)
    end

    def get_clean_header(sio)
      header = sio.readline.strip
      if header[-1] != '"'
        sio.readline # discard blank line
        header = "#{header} #{sio.readline.strip}"
      end

      header
    end

    def do_get
      resp = @conn.get(@page)
      if resp.success?
        resp.body.freeze
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
