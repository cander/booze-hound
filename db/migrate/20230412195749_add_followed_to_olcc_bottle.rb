class AddFollowedToOlccBottle < ActiveRecord::Migration[7.0]
  def change
    add_column :olcc_bottles, :followed, :boolean, default: false
  end
end
