class RemoveColumnInheritProductConfigsFromModules < ActiveRecord::Migration[5.2]
  def change
    remove_column :modulees, :inherit_product_configs if column_exists?(:modulees, :inherit_product_configs)
  end
end
