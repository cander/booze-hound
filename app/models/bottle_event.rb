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
end
