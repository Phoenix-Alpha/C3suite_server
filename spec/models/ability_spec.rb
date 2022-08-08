require 'rails_helper'
require 'capybara/rspec'
require "cancan/matchers"

describe "Ability" do
  describe "as manage" do
    it "can manage all" do
      user = user_with_role 'Admin'

      ability = Ability.new(user)
      expect(ability).to be_able_to(:manage, :all)
    end
  end

  describe "as product manager" do
    it "can read Product and User" do
      user = user_with_role 'Product Manager'

      ability = Ability.new(user)
      expect(ability).to be_able_to(:read, Product)
      expect(ability).to be_able_to(:read, User)
    end
  end

  describe "as content instructor" do
    it "can read Product" do
      user = user_with_role 'Instructor'

      ability = Ability.new(user)
      expect(ability).to be_able_to(:read, Product)
    end
  end

  pending "as normal user" do
    it "can read Product" do
      role = FactoryBot.create(:role)
      user = FactoryBot.create(:user, roles: [role])

      ability = Ability.new(user)
      expect(ability).to be_able_to(:read, Product)
    end
  end

  private

  def user_with_role (role_name = nil)
    role = FactoryBot.create(:role, name: role_name)
    user = FactoryBot.create(:user, roles: [role])

    user
  end
end
