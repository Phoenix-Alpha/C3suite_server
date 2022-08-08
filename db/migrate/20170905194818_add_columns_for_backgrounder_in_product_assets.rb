class AddColumnsForBackgrounderInProductAssets < ActiveRecord::Migration[5.1]
  def change
    add_column :product_assets, :uri_processing, :boolean, null: false, default: false
    add_column :product_assets, :uri_tmp, :string
  end
end
