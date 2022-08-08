class AddAuditSettingInProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :audit_setting, :text
  end
end
