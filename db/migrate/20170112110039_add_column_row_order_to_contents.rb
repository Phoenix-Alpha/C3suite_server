class AddColumnRowOrderToContents < ActiveRecord::Migration[5.1]
  def change
    add_column :contents, :row_order, :integer
  end
end
