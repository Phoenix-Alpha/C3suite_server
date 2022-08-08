require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Bundles' do
  header "Authorization", :authorization

  let!(:role) { create(:role) }
  let!(:user) { create(:user, roles: [role]) }
  let!(:bundle) { create(:bundle) }
  let(:authorization) { token_generator(user.id) }
  
  get "api/v1/bundles/:id" do
    example 'Get a bundle for a given ID' do
      explanation "Use this endpoint to get a single bundle against the given ID"
      
      do_request(id: bundle.id)
      expect(status).to eq(200)
      expect(JSON.parse(response_body)["success"]).to eq(true)
    end
  end

end