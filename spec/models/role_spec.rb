require 'rails_helper'

RSpec.describe Role, type: :model do
  it "is valid with a valid name" do
    role = FactoryBot.create(:role)
    expect(role).to be_valid
  end

  it "is not valid with a blank name" do
    role = Role.new
    expect(role).to be_invalid
  end

  it "is not valid with a duplicated name" do
    role = Role.create(name: 'Test Role 1')
    new_role = Role.create(name: 'Test Role 1')

    expect(new_role).to be_invalid
  end

  it "should return all the roles expect the ones passed as parameter" do
    role = FactoryBot.create(:role)
    role_new = Role.create(name: 'Test Role 2')

    result = Role.all_except(role).first

    expect(result).to eq(role_new.id)
  end

end
