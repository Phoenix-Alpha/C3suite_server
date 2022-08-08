class AddConfigurationsToModulee < ActiveRecord::Migration[5.2]
  def change
    add_column :modulees, :configurations, :text
  end
end
