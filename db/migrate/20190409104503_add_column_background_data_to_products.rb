class AddColumnBackgroundDataToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :background_data, :string
  end
end
