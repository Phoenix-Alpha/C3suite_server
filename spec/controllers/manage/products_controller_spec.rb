require 'rails_helper'

RSpec.describe Manage::ProductsController, type: :controller do
	describe "Create Product" do
		it "has stirpe product and price ids" do
			user = FactoryBot.create(:user, roles: [FactoryBot.create(:role)])
			sign_in user
			
			# product = FactoryBot.create(:product)
			
			
			product_attrs = FactoryBot.attributes_for(:product)
			post :create, params: {product: product_attrs}
			
			expect(assigns(:product).stripe).not_to eq(nil)
			expect(assigns(:product).stripe).not_to eq({})
			expect(assigns(:product).stripe[:product_id]).not_to eq(nil)
			expect(assigns(:product).stripe[:price_id]).not_to eq(nil)
		end
	end
end
