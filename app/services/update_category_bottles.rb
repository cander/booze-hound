class UpdateCategoryBottles < ApplicationService
  def initialize(client, category)
    @client = client
    @cateogy = category
  end

  def call
    bottles = @client.get_category_bottles(@category)
    bottles.each do |cat_bottle|
      bottle = OlccBottle.find_by(new_item_code: cat_bottle.new_item_code)
      if bottle
        update_existing_bottle(bottle, cat_bottle)
      else
        insert_new_bottle(cat_bottle)
      end
    end
  end

  def update_existing_bottle(bottle, new_bottle)
    # watch for followed flag
    bottle.assign_attributes(new_bottle.to_h)
    changes = bottle.changes_to_save
    bottle.save!
    # create event
    puts changes # WIP
  end

  def insert_new_bottle(new_bottle)
    OlccBottle.create(new_bottle.to_h)
    # create event
  end
end
