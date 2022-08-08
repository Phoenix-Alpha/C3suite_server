require 'rails_helper'
require "active_record/acts_as/matchers"

RSpec.describe Modulee, type: :model do
  let(:modulee_new) { FactoryBot.build(:modulee) }

  it { is_expected.to act_as(Content) }

  it "is valid with valid attributes" do
    modulee = FactoryBot.create(:modulee)
    expect(modulee).to be_valid
  end
end
