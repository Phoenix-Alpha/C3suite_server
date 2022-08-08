class AddAssetKindToProductAssets < ActiveRecord::Migration[5.1]
  def change
    add_column :product_assets, :kind, :integer
  end
end
