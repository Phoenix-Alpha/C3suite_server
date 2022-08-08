class AddColumnSourceDataToContentAssets < ActiveRecord::Migration[5.2]
  def change
  	add_column :content_assets, :source_data, :text
  end
end
