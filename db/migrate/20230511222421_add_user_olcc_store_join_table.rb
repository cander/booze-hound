class AddUserOlccStoreJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_table :olcc_stores_users, id: false do |t|
      t.string "store_num"   # really: t.belongs_to :olcc_store, association_foreign_key: "store_num"
      t.belongs_to :user
    end

    add_index :olcc_stores_users, :store_num
  end
end
