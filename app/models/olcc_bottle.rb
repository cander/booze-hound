class OlccBottle < ApplicationRecord
  self.primary_key = "new_item_code"
  has_many :bottle_events, foreign_key: "new_item_code"
  has_and_belongs_to_many :followers, class_name: "User", foreign_key: "new_item_code"

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
    OlccBottle.where("followers_count > 0").order(:category)
  end

  def self.search(unsafe_query)
    safe_query = OlccBottle.sanitize_sql_like(unsafe_query)
    OlccBottle.where("name LIKE ?", "%" + safe_query + "%")
  end
end
