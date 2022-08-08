class CreateProductAssetKinds < ActiveRecord::Migration[5.1]
  def change
    create_table :product_asset_kinds do |t|
      t.string :description
      t.string :alternates
      t.string :kind

      t.timestamps
    end
  end
end
