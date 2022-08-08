class RenameColumnTypeOfMediaTable < ActiveRecord::Migration[5.1]
  def change
    rename_column :media, :type, :local_type
  end
end
