class CreateOlccInventories < ActiveRecord::Migration[7.0]
  def change
    create_table :olcc_inventories do |t|
      t.integer :quantity
      t.string :new_item_code
      t.string :store_num

      t.timestamps
    end
  end
end
