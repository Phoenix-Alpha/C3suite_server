class AddBundleColumnInBundleAssets < ActiveRecord::Migration[5.2]
  def change
    add_column :bundle_assets, :bundle_id, :bigint
  end
end
