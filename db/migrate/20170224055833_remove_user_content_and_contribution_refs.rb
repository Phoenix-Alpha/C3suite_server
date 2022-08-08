class RemoveUserContentAndContributionRefs < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :contributions, :products if data_source_exists?(:contributions) && foreign_key_exists?(:contributions, :product_id)
    remove_foreign_key :user_contents, :users if data_source_exists?(:user_contents) && foreign_key_exists?(:user_contents, :user_id)

    drop_table :contributions if data_source_exists?(:contributions)
    drop_table :user_contents if data_source_exists?(:user_contents)
  end
end
