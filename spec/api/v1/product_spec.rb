require 'rails_helper'

RSpec.describe 'API/v1 products', type: :request do

  let!(:products) { create_list(:product, 3)}

  describe 'when unathorized' do
    describe 'GET products' do
      it 'returns an error' do
        get '/api/v1/products'
        expect(json['message']).to match(/Missing token/)
      end
    end
  end

  describe 'when authorized' do
    # create test user
    let!(:role) { create(:role) }
    let!(:user) { create(:user, roles: [role]) }
    # set headers for authorization
    let(:headers) { valid_headers }


    describe 'GET products' do
      before { get '/api/v1/products', headers: headers }

      it 'returns products' do
        expect(json).not_to be_empty
        expect(json.size).to eq(3)
      end
    end
  end

end