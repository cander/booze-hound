class AddFollowersCountToOlccStores < ActiveRecord::Migration[7.0]
  def change
    add_column :olcc_stores, :followers_count, :integer, default: 0
  end
end
