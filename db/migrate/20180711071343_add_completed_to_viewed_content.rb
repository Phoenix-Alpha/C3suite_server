class AddCompletedToViewedContent < ActiveRecord::Migration[5.1]
  def change
    add_column :viewed_contents, :completed, :boolean, :default => false
  end
end
