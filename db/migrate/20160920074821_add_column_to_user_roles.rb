class AddColumnToUserRoles < ActiveRecord::Migration[5.1]
  def change
    add_column :user_roles, :user_id, :bigint
    add_column :user_roles, :role_id, :bigint
  end
end
