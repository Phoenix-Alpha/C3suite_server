class RemoveExtraFieldsFromProducts < ActiveRecord::Migration[5.2]
  def change
    remove_column :products, :name if column_exists?(:products, :name)
    remove_column :products, :audit_setting if column_exists?(:products, :audit_setting)
  end
end
