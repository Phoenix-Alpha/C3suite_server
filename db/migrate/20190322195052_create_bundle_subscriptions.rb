class CreateBundleSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :bundle_subscriptions do |t|
      t.integer :user_id
      t.integer :bundle_id
      t.timestamps
    end
  end
end
