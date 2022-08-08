class RemoveProductassetUriFieldCreatedForCarrierwave < ActiveRecord::Migration[5.2]
  def change
    remove_column :product_assets, :uri
    remove_column :product_assets, :uri_tmp
    remove_column :product_assets, :uri_processing
  end
end
