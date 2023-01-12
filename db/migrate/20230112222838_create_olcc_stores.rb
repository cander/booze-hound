class CreateOlccStores < ActiveRecord::Migration[7.0]
  def change
    create_table :olcc_stores, primary_key: [:store_num] do |t|
      t.string :store_num
      t.string :name
      t.string :location
      t.string :address
      t.integer :zip
      t.string :telephone
      t.string :store_hours

      t.timestamps
    end
  end
end
