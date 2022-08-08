class RemovePermalinkFromProducts < ActiveRecord::Migration[5.1]
  def change
    remove_column :products, :permalink, :string
  end
end
