class AddColumnAppStoreBundleIdInProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :app, :text
  end
end
