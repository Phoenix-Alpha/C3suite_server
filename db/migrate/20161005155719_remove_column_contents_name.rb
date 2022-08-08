class RemoveColumnContentsName < ActiveRecord::Migration[5.1]
  def change
    remove_column :contents, :name
  end
end
