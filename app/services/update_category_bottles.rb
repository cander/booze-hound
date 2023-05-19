class UpdateCategoryBottles < ApplicationService
  def initialize(client, category)
    @client = client
    @category = category
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
    attrs = new_bottle.to_h
    bottle.assign_attributes(attrs)
    if bottle.changed?
      changes = bottle.changes_to_save
      bottle.save!
      BottleEvent.update_bottle(bottle, changes)
    end
  end

  def insert_new_bottle(new_bottle)
    attrs = new_bottle.to_h
    bottle = OlccBottle.create!(attrs)
    BottleEvent.new_bottle(bottle, attrs)
  end
end
