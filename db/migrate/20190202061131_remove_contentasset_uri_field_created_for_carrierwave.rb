class RemoveContentassetUriFieldCreatedForCarrierwave < ActiveRecord::Migration[5.2]
  def change
    remove_column :content_assets, :uri
    remove_column :content_assets, :uri_tmp
    remove_column :content_assets, :uri_processing
  end
end
