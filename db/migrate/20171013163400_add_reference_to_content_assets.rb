class AddReferenceToContentAssets < ActiveRecord::Migration[5.1]
  def change
    add_reference :content_assets, :contents, foreign_key: true
  end
end
