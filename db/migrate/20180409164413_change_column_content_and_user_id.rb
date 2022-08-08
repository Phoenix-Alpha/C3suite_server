class ChangeColumnContentAndUserId < ActiveRecord::Migration[5.1]
  def change
    rename_column :viewed_contents, :users_id, :user_id
    rename_column :viewed_contents, :contents_id, :content_id
  end
end
