require 'rails_helper'
require "active_record/acts_as/matchers"

RSpec.describe Content, type: :model do
  it { expect(Content).to be_actable }

  it { should belong_to(:product) }

  it "is valid with valid attributes" do
    content = FactoryBot.create(:content)
    expect(content).to be_valid
  end

end
