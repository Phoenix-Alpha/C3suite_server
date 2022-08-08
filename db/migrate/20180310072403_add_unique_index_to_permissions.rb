class AddUniqueIndexToPermissions < ActiveRecord::Migration[5.1]
  def change
    add_index :permissions, [:user_id, :product_id], unique: true
  end
end
