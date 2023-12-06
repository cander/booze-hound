class AddUsernameToUsers < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :username, :string, limit: 24

    # migrate existing users - add usernames
    User.all.each do |u|
      at_loc = u.email.index("@")
      username = at_loc ? u.email.first(at_loc) : u.email
      puts "migrating: #{username}"
      u.update(username: username)
    end

    # have to set this after all users have usernames
    change_column :users, :username, :string, null: false
  end

  def down
    remove_column :users, :username
  end
end
