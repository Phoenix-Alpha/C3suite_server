class ChangeRemainingTimeToIntViewedContent < ActiveRecord::Migration[5.1]
  def change
    change_column :viewed_contents, :remaining_time, :integer
  end
end
