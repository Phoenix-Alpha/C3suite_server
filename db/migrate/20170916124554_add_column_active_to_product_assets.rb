class AddColumnActiveToProductAssets < ActiveRecord::Migration[5.1]
  def change
    add_column :product_assets, :active, :boolean, default: false
  end
end
