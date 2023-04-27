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

  def self.new_bottle(bottle, attrs)
    create(olcc_bottle: bottle, event_type: "NEW BOTTLE", details: attrs)
  end

  def self.update_bottle(bottle, changes)
    create(olcc_bottle: bottle, event_type: "DESCRIPTION CHANGE", details: changes)
  end

  def self.new_inventory(inv)
    dets = {store_num: inv.store_num, quantity: inv.quantity}
    create(new_item_code: inv.new_item_code, event_type: "NEW INVENTORY", details: dets)
  end
end
