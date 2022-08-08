class RemoveContentsKindAndPayloadColumns < ActiveRecord::Migration[5.1]
  def change
    remove_column :contents, :kind
    remove_column :contents, :payload
  end
end
