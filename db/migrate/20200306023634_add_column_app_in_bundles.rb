class AddColumnAppInBundles < ActiveRecord::Migration[5.2]
  def change
    add_column :bundles, :app, :text
  end
end
