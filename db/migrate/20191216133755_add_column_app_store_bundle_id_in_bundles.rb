class AddColumnAppStoreBundleIdInBundles < ActiveRecord::Migration[5.2]
  def change
    add_column :bundles, :app_store_bundle_id, :string
  end
end
