class AddTimeToContents < ActiveRecord::Migration[5.1]
  def change
    add_column :contents, :time, :integer
  end
end
