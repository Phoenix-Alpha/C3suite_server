class AddColumnAuditableToModulees < ActiveRecord::Migration[5.1]
  def change
    add_column :modulees, :auditable, :boolean, default: false
  end
end
