class AddColumnTransactionIdToUserSubscription < ActiveRecord::Migration[5.2]
  def change
    add_column :user_subscriptions, :transaction_id, :string
  end
end
