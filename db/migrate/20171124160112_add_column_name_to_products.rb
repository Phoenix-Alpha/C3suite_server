class AddColumnNameToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :name, :string, unique: true
  end
end
