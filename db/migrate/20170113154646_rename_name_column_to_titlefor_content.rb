class RenameNameColumnToTitleforContent < ActiveRecord::Migration[5.1]
  def change
    rename_column :contents, :name, :title
  end
end
