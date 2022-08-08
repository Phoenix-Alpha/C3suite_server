class AddSeedDataForInstructor < ActiveRecord::Migration[5.1]
  def change
    roles = [{name: 'Instructor'}].freeze

    roles.each do |role|
      Role.create(role) if Role.find_by_name(role[:name]).blank?
    end
  end
end
