class User < ApplicationRecord
  has_and_belongs_to_many :following_bottles, class_name: "OlccBottle", association_foreign_key: "new_item_code"
end
