class AddColumnsPermaToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :permalink, :string
  end
end
