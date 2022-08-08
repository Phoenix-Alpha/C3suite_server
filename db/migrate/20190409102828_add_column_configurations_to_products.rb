class AddColumnConfigurationsToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :configurations, :text
  end
end
