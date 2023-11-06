class LoadBottle < ApplicationService
  def initialize(client, category, new_item_code)
    @client = client
    # old_item_code isn't needed, but maybe category is?
    @category = category
    @new_item_code = new_item_code
  end

  def call
    bottle_data = @client.get_bottle_details(@category, @new_item_code)
    bottle = OlccBottle.find_by(new_item_code: @new_item_code)
    if bottle
      return nil if !bottle.update(bottle_data.to_h) # could capture errors
    else
      bottle = OlccBottle.new(bottle_data.to_h)
      return nil if !bottle.save  # could capture errors
    end

    bottle
  rescue => e
    # NB: this is a wide net to cast for catching errors
    # Want to handle the OLCC client errors separately? And report through error API
    logger.error("Exception loading bottle #{@new_item_code}: #{e}")
    nil
  end
end
