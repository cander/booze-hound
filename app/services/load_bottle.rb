class LoadBottle < ApplicationService
  def initialize(client, category, new_item_code, old_item_code)
    @client = client
    # old_item_code isn't needed, but maybe category is?
    @category = category
    @new_item_code = new_item_code
    @old_item_code = old_item_code
  end

  def call
    bottle = OlccBottle.find_by(new_item_code: @new_item_code)
    return bottle if bottle

    bottle_data = @client.get_bottle_details(@category, @new_item_code, @old_item_code)
    OlccBottle.create(bottle_data.to_h)
  rescue RuntimeError
    puts "exception finding bottle #{@new_item_code}"
    nil
  end
end
