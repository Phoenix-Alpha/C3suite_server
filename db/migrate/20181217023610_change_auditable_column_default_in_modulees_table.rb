class ChangeAuditableColumnDefaultInModuleesTable < ActiveRecord::Migration[5.1]
  def change
    change_column :modulees, :auditable, :boolean, default: false
  end
end
