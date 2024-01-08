class BottleEvent < ApplicationRecord
  belongs_to :olcc_bottle, foreign_key: "new_item_code"
  serialize :details, JSON

  TYPES = [
    "NEW BOTTLE",
    "NEW INVENTORY",
    "PRICE CHANGE",
    "DESCRIPTION CHANGE"
  ].freeze
  enum event_type: TYPES.index_by(&:to_s)
  EVENTS_PER_PAGE = 20

  def self.recents(bottle_ids, categories, page = 0)
    # new bottles and events on bottles we already follow
    result = BottleEvent.joins(:olcc_bottle)
      # new bottles in categories we follow
      .where(event_type: "NEW BOTTLE").where("olcc_bottles.category IN (?)", categories)
      # other events for bottles we follow
      .or(BottleEvent.where(new_item_code: bottle_ids))
      .order(created_at: :desc).limit(EVENTS_PER_PAGE)
    if page > 0
      result = result.offset(page * EVENTS_PER_PAGE)
    end
    result = result.includes(:olcc_bottle)

    result.to_a
  end

  def self.new_bottle(bottle, attrs)
    create(olcc_bottle: bottle, event_type: "NEW BOTTLE", details: attrs)
  end

  def self.update_bottle(bottle, changes)
    type = if (changes.size == 1) && changes.has_key?(:bottle_price)
      "PRICE CHANGE"
    else
      "DESCRIPTION CHANGE"
    end
    create(olcc_bottle: bottle, event_type: type, details: changes)
  end

  def self.new_inventory(inv)
    dets = {store_num: inv.store_num, quantity: inv.quantity}
    create(new_item_code: inv.new_item_code, event_type: "NEW INVENTORY", details: dets)
  end
end
