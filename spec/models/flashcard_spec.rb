require 'rails_helper'
require "active_record/acts_as/matchers"

RSpec.describe Flashcard, type: :model do
  it { is_expected.to act_as(Content) }

  it "is valid with valid attributes" do
    flashcard = FactoryBot.create(:flashcard)
    expect(flashcard).to be_valid
  end
end
