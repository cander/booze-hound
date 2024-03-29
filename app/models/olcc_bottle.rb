class OlccBottle < ApplicationRecord
  self.primary_key = "new_item_code"
  has_many :bottle_events, foreign_key: "new_item_code"
  has_and_belongs_to_many :followers, class_name: "User", foreign_key: "new_item_code"

  # description is ALL CAPS from OLCC. name is a more user-friendly
  # version - give it an initial mixed-case value based on description.
  before_create do
    self.name = description.titleize if name.blank?
    self.next_bottle_price = bottle_price if next_bottle_price.nil?
  end
  # and keep it in sync if the description changes
  before_update do
    sync_name_to_description

    if bottle_price_changed?
      # synchronize next_bottle price unless it changed too
      self.next_bottle_price = bottle_price unless next_bottle_price_changed?
    end
  end

  CATEGORIES = [
    "BRANDY / COGNAC",
    "CACHACA",
    "CORDIALS",
    "DOMESTIC WHISKEY",
    "GIN",
    "IRISH",
    "RUM",
    "TEQUILA",
    "VODKA"
  ].freeze
  enum category: CATEGORIES.index_by(&:to_s)

  def self.followed_bottles
    # order by category so each category will show up as a block together
    OlccBottle.where("followers_count > 0").order(:category)
  end

  def self.search(unsafe_query)
    safe_query = OlccBottle.sanitize_sql_like(unsafe_query)
    OlccBottle.where("name LIKE ?", "%" + safe_query + "%").order(:name)
  end

  # After adding the before_create hook, this might be obsolete
  def prettify_name(better_name = nil)
    if better_name
      self.name = better_name
    elsif name == description
      self.name = name.titleize
    end

    save
  end

  private

  def sync_name_to_description
    desc_change = changes_to_save[:description]
    if desc_change
      prev_desc = desc_change.first
      if name == prev_desc.titleize
        # the name is the default based on the previous description
        self.name = description.titleize
      end
    end
  end
end
