class AddContentIdToContentAssets < ActiveRecord::Migration[5.1]
  def change
    add_column :content_assets, :content_id, :integer
  end
end
