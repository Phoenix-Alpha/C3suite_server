require 'rails_helper'

RSpec.describe Product, type: :model do  
  it { should have_many(:contents) }
  
  it "is valid with valid attributes" do
    product = FactoryBot.create(:product)
    expect(product).to be_valid
  end

  it "is not valid without a title" do
    product = Product.new(visibility: "All")
    expect(product).to be_invalid
  end

  it "is not valid without visibility" do
    product = Product.new(title: "Test Product 1")
  	expect(product).to be_invalid
  end
end
