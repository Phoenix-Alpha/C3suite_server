require 'rails_helper'

RSpec.describe UserRole, type: :model do
  it {
    ur = UserRole.new

    expect(ur).to belong_to(:user)
    expect(ur).to belong_to(:role)
  }
end
