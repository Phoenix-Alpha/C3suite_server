require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Products' do
  header "Authorization", :authorization

  let!(:role) { create(:role) }
  let!(:user) { create(:user, roles: [role]) }
  let!(:product) { create(:product) }
  let(:authorization) { token_generator(user.id) }
  let!(:products) { create_list(:product, 3) }
  let(:quiz_content) { build_quiz_hierarchy }

  get 'api/v1/products' do
    example 'Get all products' do
      explanation "Use this endpoint to get all products"
      do_request
      expect(status).to eq(200)
    end
  end

  get "api/v1/products/:id" do
    example 'Get product by ID' do
      explanation "Use this endpoint to get a single product against the given ID"
      
      do_request(id: product.id)
      expect(status).to eq(200)
      expect(JSON.parse(response_body)["success"]).to eq(true)
    end
  end

  get 'api/v1/products/:id/exams' do
    example 'Get all exams' do
      explanation "Use this endpoint to get all exams for a product ID"
      
      do_request(id: quiz_content.product.id)
      expect(status).to eq(200)
      expect(JSON.parse(response_body)["success"]).to eq(true)
    end
  end

  get 'api/v1/products/:id/questions' do
    example 'Get all questions' do
      explanation "Use this endpoint to get all questions for a product ID"
      
      do_request(id: quiz_content.product.id)
      expect(status).to eq(200)
      expect(JSON.parse(response_body)["success"]).to eq(true)
    end
  end

  get "api/v1/products/:id/subscribe" do
    parameter :charge, "Charge id returned by stripe api on successful purchase"
    parameter :customer, "Stripe customer id for user"
    
    let(:customer) { user.stripe_customer_id }
    
    example 'Subscribe product for android' do
      explanation "Use this endpoint to create stirpe user subscription given stirpe customer and charge id"
      do_request(id: product.id)
      expect(status).to eq(200)
      expect(JSON.parse(response_body)["success"]).to eq(true)
    end
  end

  get "api/v1/products/:id/app_store_subscription" do
    parameter :receipt_data, "Base64-Encoded Receipt Data from app store"
    parameter :transaction_id, "Transaction id returned from app store on successful purchase"
    parameter :expires_date, "The expiry date for subscription returned from app store"
    
    let(:receipt_data) { "9010a795349cf7bd5813768ea653cc628a03ad2b953b9b2d" }
    let(:transaction_id) { "9010a795349cf7bd5813768ea653cc628a03ad2b953b9b2d" }
    let(:expires_date) { "9010a795349cf7bd5813768ea653cc628a03ad2b953b9b2d" }
    
    example 'Subscribe product for ios' do
      explanation "Use this endpoint to creates user subscription given ios specific purchase data"      
      do_request(id: product.id)
      expect(status).to eq(200)
      expect(JSON.parse(response_body)["success"]).to eq(true)
    end
  end

  get 'api/v1/products/:id/contents' do
    example 'Get all contents for a product' do
      explanation "Use this endpoint to get all the contents for a product"
      
      do_request(id: product.id)
      expect(status).to eq(200)
    end
  end
end