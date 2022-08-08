class ChangeColumnTypesForDelayedJob < ActiveRecord::Migration[5.1]
  def change
    change_column :delayed_jobs, :handler, :longtext, null: false
    change_column :delayed_jobs, :last_error, :longtext
  end
end
