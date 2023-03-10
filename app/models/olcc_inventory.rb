class OlccInventory < ApplicationRecord
  belongs_to :olcc_bottle, foreign_key: "new_item_code"
  belongs_to :olcc_store, foreign_key: "store_num"

  scope :in_stock, -> { where("quantity > 0") }
end
