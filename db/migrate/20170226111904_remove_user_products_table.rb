class RemoveUserProductsTable < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :user_products, :users if data_source_exists?(:user_products) && foreign_key_exists?(:user_products, :user_id)
    drop_table :user_products if data_source_exists?(:user_products)
  end
end
