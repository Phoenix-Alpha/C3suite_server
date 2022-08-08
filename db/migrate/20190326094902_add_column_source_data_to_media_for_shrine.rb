class AddColumnSourceDataToMediaForShrine < ActiveRecord::Migration[5.2]
  def change
  	add_column :media, :source_data, :text
  end
end
