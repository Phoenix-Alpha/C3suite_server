class AddColumnHasBookmarkToModulee < ActiveRecord::Migration[5.1]
  def change
    add_column :modulees, :has_bookmarks, :boolean
  end
end
