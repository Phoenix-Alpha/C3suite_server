class ChangeColumnTokenTextForUserSubscription < ActiveRecord::Migration[6.0]
  def change
    change_column :user_subscriptions, :token, :text
  end
end
