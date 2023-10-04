class User < ApplicationRecord
  has_and_belongs_to_many :following_bottles, class_name: "OlccBottle", association_foreign_key: "new_item_code",
    after_add: :increment_bottle_counter_cache, after_remove: :decrement_bottle_counter_cache
  has_and_belongs_to_many :favorite_stores, class_name: "OlccStore", association_foreign_key: "store_num",
    after_add: :increment_store_counter_cache, after_remove: :decrement_store_counter_cache

  def is_following?(bottle)
    following_bottles.include?(bottle)
  end

  def follow_bottle(bottle)
    unless is_following?(bottle)
      following_bottles << bottle
    end
  end

  def unfollow_bottle(bottle)
    if is_following?(bottle)
      following_bottles.delete(bottle)
    end
  end

  def is_favorite_store?(store)
    favorite_stores.include?(store)
  end

  def favor_store(store)
    unless is_favorite_store?(store)
      favorite_stores << store
    end
  end

  def unfavor_store(store)
    if is_favorite_store?(store)
      favorite_stores.delete(store)
    end
  end

  private

  def increment_bottle_counter_cache(bottle)
    bottle.increment!(:followers_count)
  end

  def decrement_bottle_counter_cache(bottle)
    bottle.decrement!(:followers_count)
  end

  def increment_store_counter_cache(store)
    store.increment!(:followers_count)
  end

  def decrement_store_counter_cache(store)
    store.decrement!(:followers_count)
  end
end
