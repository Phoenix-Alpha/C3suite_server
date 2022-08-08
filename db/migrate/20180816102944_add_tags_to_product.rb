class AddTagsToProduct < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :tags, :text
  end
end
