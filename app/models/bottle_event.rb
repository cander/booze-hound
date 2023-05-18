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

  def self.recents(since = 1.week.ago)
    # new bottles and events on bottles we already follow
    # TODO: this isn't right - this includes any bottles that are followed
    # by anyone
    BottleEvent.joins(:olcc_bottle).includes(:olcc_bottle)
      .where("bottle_events.event_type = 'NEW BOTTLE' OR (bottle_events.created_at > ? AND olcc_bottles.followers_count > 0)", since)
      .order(created_at: :desc).limit(20)
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
