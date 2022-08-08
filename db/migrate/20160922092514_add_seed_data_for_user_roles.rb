class AddSeedDataForUserRoles < ActiveRecord::Migration[5.1]
  def change
    # Add roles to the database if they don't already exist
    roles = ['Admin', 'Product Manager', 'Content Contributor', 'Instructor', 'Customer']

    roles.each do |role|
      Role.find_or_create_by(name: role)
    end

    # Add "Admin" role for all the existing Admin users
    admin_role = Role.find_by_name('Admin')
    User.all.each do |user|
      if user.isadmin?
        user.user_roles = [UserRole.create(user_id: user.id, role_id: admin_role.id)] unless admin_role.blank?
        user.save!  unless user.user_roles.blank?
      end
    end

    # Remove isadmin column from Users, not needed since we now have Roles
    remove_column :users, :isadmin
  end
end
