class ProcessNextMonth < ApplicationService
  def initialize(log, mock_fetcher = nil)
    @fetcher = mock_fetcher || OlccWeb::FetchPriceList.get_next_month(log)
  end

  def call
    rows = @fetcher.get_bottles
    total_bottles = found_bottles = updated_bottles = 0

    rows.each do |row|
      total_bottles += 1
      bottle = OlccBottle.find_by(new_item_code: row.new_item_code)
      if bottle
        found_bottles += 1
        bottle.next_bottle_price = row.bottle_price
        if bottle.changed?
          bottle.save!
          updated_bottles += 1
          logger.info { "$#{bottle.next_bottle_price} is next month's price for #{bottle.name} - #{bottle.new_item_code}" }
        end
      end
    end

    logger.info { "Processed #{total_bottles} total bottles, found #{found_bottles} bottles, and updated #{updated_bottles}" }
  rescue OlccWeb::ApiError => e
    logger.error("Exception fetching next month's price data: #{e}")
    raise e
  end
end
