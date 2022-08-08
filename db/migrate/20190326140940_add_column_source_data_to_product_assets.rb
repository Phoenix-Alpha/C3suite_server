class AddColumnSourceDataToProductAssets < ActiveRecord::Migration[5.2]
  def change
  	add_column :product_assets, :source_data, :text
  end
end
