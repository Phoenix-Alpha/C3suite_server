class RenameProductAssetKindToAssetKind < ActiveRecord::Migration[5.1]
  def change
    rename_table :product_asset_kinds, :asset_kinds
  end
end
