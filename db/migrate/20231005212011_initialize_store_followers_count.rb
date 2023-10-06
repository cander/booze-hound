class InitializeStoreFollowersCount < ActiveRecord::Migration[7.0]
  # After adding the followers_count attribute to OlccStores, update the
  # existing stores in the DB to reflect existing followers, based on the
  # olcc_stores_users join table in the DB. This could/should have been part
  # of the migration that added that column.
  def up
    # Let's assume there is only one user in the DB
    u = User.first
    puts "Updating followers_count on #{u.favorite_store_ids.count} out of #{OlccStore.count} stores..."
    u.favorite_store_ids.each do |store_num|
      store = OlccStore.find(store_num)
      store.update(followers_count: 1)
    end
  end

  def down
    OlccStore.update_all(followers_count: 0)
  end
end
