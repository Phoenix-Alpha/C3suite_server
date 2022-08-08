class AddUsernameToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :username, :string
    add_column :users, :isadmin, :bool, :default => false
  end
end
