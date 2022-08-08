class CreateUserSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :user_subscriptions do |t|
      t.integer :user_id
      t.integer :product_id
      t.date :sub_start
      t.date :sub_end
      t.string :token

      t.timestamps
    end
  end
end
