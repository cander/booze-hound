class User < ApplicationRecord
  has_and_belongs_to_many :following_bottles, class_name: "OlccBottle", association_foreign_key: "new_item_code",
    after_add: :increment_bottle_counter_cache, after_remove: :decrement_bottle_counter_cache

  def increment_bottle_counter_cache(bottle)
    bottle.increment!(:followers_count)
  end

  def decrement_bottle_counter_cache(bottle)
    bottle.decrement!(:followers_count)
  end
end
