class AddIndexesToInventory < ActiveRecord::Migration[7.0]
  def change
    change_table :olcc_inventories do |t|
      t.index :new_item_code
    end

    change_table :bottle_events do |t|
      t.index :created_at
    end
  end
end
