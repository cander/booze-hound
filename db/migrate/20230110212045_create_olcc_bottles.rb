class CreateOlccBottles < ActiveRecord::Migration[7.0]
  def change
    create_table :olcc_bottles, primary_key: [:new_item_code]  do |t|
      t.string :new_item_code
      t.string :old_item_code
      t.string :name
      t.string :size
      t.decimal :proof
      t.string :age

      t.timestamps
    end
  end
end
