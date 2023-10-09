class OlccStore < ApplicationRecord
  self.primary_key = "store_num"
  has_and_belongs_to_many :followers, class_name: "User", foreign_key: "store_num"

  def self.search(unsafe_query)
    safe_query = OlccStore.sanitize_sql_like(unsafe_query)
    OlccStore.where("name LIKE ?", "%" + safe_query + "%").order(:name)
  end
end
