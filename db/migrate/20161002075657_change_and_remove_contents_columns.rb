class ChangeAndRemoveContentsColumns < ActiveRecord::Migration[5.1]
  def change
    rename_column :contents, :parent, :parent_id
    remove_column :contents, :follows
  end
end
