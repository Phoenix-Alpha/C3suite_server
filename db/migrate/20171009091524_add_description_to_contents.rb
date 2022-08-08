class AddDescriptionToContents < ActiveRecord::Migration[5.1]
  def change
    add_column :contents, :description, :text
  end
end
