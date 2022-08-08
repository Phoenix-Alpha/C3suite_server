class AddColumnTempFilePathToMediaTable < ActiveRecord::Migration[5.1]
  def change
    add_column :media, :source_tmp, :string
    add_column :media, :source_processing, :boolean, null: false, default: false
  end
end
