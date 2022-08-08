class AddTimestampToViewedContent < ActiveRecord::Migration[5.1]
  def change
    add_column :viewed_contents, :remaining_time, :string
  end
end
