require 'rails_helper'
require "active_record/acts_as/matchers"

RSpec.describe Quiz, type: :model do
  it { is_expected.to act_as(Content) }

  it "is valid with valid attributes" do
    quiz = FactoryBot.create(:quiz)
    expect(quiz).to be_valid
  end
end
