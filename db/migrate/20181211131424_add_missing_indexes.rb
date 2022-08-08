class AddMissingIndexes < ActiveRecord::Migration[5.1]
  def change
    add_index :product_assets, :product_id
    add_index :user_subscriptions, :product_id
    add_index :user_subscriptions, :user_id
    add_index :user_subscriptions, [:product_id, :user_id]
  end
end
