require 'rails_helper'
require "active_record/acts_as/matchers"

RSpec.describe Html, type: :model do
  it { is_expected.to act_as(Content) }

  it "is valid with valid attributes" do
    html = FactoryBot.create(:html)
    expect(html).to be_valid
  end
end
