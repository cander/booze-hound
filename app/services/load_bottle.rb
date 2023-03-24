class LoadBottle < ApplicationService
  def initialize(client, category, new_item_code, old_item_code)
    @client = client
    @category = category
    @new_item_code = new_item_code
    @old_item_code = old_item_code
  end

  def call
    bottle = @client.get_bottle_details(@cat, @new_item_code, @old_item_code)
    OlccBottle.upsert(bottle.to_h)
  end
end
