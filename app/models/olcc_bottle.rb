class OlccBottle < ApplicationRecord
  self.primary_key = "new_item_code"

  CATEGORIES = [
    "CACHACA",
    "DOMESTIC WHISKEY",
    "GIN",
    "RUM",
    "TEQUILA"
  ].freeze
  enum category: CATEGORIES.index_by(&:to_s)

  def self.followed_bottles
    # order by category so each category will show up as a block together
    OlccBottle.where(followed: true).order(:category)
  end
end
