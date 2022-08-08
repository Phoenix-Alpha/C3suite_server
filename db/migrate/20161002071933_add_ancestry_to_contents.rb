class AddAncestryToContents < ActiveRecord::Migration[5.1]
  def change
    add_column :contents, :ancestry, :string
    add_index :contents, :ancestry
  end
end
