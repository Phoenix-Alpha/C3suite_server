class AddColumnInheritFromProductInModulee < ActiveRecord::Migration[5.2]
  def change
    add_column :modulees, :inherit_product_configs, :boolean, default: true
  end
end
