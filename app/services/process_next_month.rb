class ProcessNextMonth < ApplicationService
  def initialize(fetcher)
    @fetcher = fetcher
  end

  def call
    rows = @fetcher.get_bottles

    rows.each do |row|
      bottle = OlccBottle.find_by(new_item_code: row.new_item_code)
      if bottle
        bottle.next_bottle_price = row.bottle_price
        bottle.save! if bottle.changed?
      end
    end
  rescue OlccWeb::ApiError => e
    logger.error("Exception fetching next month's price data: #{e}")
    raise e
  end
end
