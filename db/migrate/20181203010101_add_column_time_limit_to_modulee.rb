class AddColumnTimeLimitToModulee < ActiveRecord::Migration[5.1]
  def change
    add_column :modulees, :time_limit, :integer
  end
end
