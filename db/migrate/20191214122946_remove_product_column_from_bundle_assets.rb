class RemoveProductColumnFromBundleAssets < ActiveRecord::Migration[5.2]
  def change
    remove_column :bundle_assets, :product_id, :bigint
  end
end
