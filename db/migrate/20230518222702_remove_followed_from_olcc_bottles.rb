class RemoveFollowedFromOlccBottles < ActiveRecord::Migration[7.0]
  def change
    remove_column :olcc_bottles, :followed, :boolean
  end
end
