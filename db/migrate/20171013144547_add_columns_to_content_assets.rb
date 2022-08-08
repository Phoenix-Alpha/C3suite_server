class AddColumnsToContentAssets < ActiveRecord::Migration[5.1]
  def change
    add_column :content_assets, :uri_processing, :boolean, null: false, default: false
    add_column :content_assets, :uri_tmp, :string
    add_column :content_assets, :active, :boolean, default: false
  end
end
