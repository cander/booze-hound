class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email, null: false
      t.string :encrypted_password

      t.timestamps
    end

    create_table :olcc_bottles_users, id: false do |t|
      t.string "new_item_code"   # really: t.belongs_to :olcc_bottle, foreign_key: "new_item_code"
      t.belongs_to :user
    end

    add_index :olcc_bottles_users, :new_item_code
  end
end
