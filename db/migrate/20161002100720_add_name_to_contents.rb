class AddNameToContents < ActiveRecord::Migration[5.1]
  def change
    add_column :contents, :name, :string
  end
end
