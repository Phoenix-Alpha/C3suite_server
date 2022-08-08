class RemoveActiveStorage < ActiveRecord::Migration[5.2]
  def change
  	drop_table :active_storage_attachments if data_source_exists?(:active_storage_attachments)
  	drop_table :active_storage_blobs if data_source_exists?(:active_storage_blobs)
  end
end
