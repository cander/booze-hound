class OlccStore < ApplicationRecord
  self.primary_key = "store_num"
  has_and_belongs_to_many :followers, class_name: "User", foreign_key: "store_num"
end
