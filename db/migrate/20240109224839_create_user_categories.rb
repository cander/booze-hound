class CreateUserCategories < ActiveRecord::Migration[7.0]
  def up
    create_table :user_categories do |t|
      t.references :user, null: false, foreign_key: true
      t.string :category

      t.timestamps
    end

    # add categories for any existing users
    User.all.each do |u|
      u.add_category("RUM")
      u.add_category("DOMESTIC WHISKEY")
    end
  end

  def down
    drop_table :user_categories
  end
end
