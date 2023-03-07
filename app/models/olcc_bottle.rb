class OlccBottle < ApplicationRecord
  self.primary_key = "new_item_code"

  CATEGORIES = [
    "DOMESTIC WHISKEY",
    "RUM",
    "TEQUILA"
  ].freeze
  enum category: CATEGORIES.index_by(&:to_s)

  def self.followed_bottles
    # currently, assume all bottles are followed
    # group by category so all the rums can be processed, etc.
    OlccBottle.group("category")
  end
end
