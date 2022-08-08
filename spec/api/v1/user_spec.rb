require 'rails_helper'

RSpec.describe 'API/v1 users', type: :request do

  describe 'POST /users/token' do

    # create test user
    let!(:role) { create(:role, name: "Customer") }
    let!(:user) { create(:user, roles: [role]) }
    # set headers for authorization
    let(:headers) { valid_headers.except('Authorization') }
    # set test valid and invalid credentials
    let(:valid_credentials) do
      {
          email: user.email,
          password: user.password
      }.to_json
    end
    let(:invalid_credentials) do
      {
          email: Faker::Internet.email,
          password: Faker::Internet.password
      }.to_json
    end

    # set request.headers to our custon headers
    # before { allow(request).to receive(:headers).and_return(headers) }

    # returns auth token when request is valid
    context 'When request is valid' do
      before { post '/api/v1/users/token', params: valid_credentials, headers: headers }
      it 'returns an authentication token' do
        expect(json['auth_token']).not_to be_nil
      end
    end

    # returns failure message when request is invalid
    context 'When request is invalid' do
      before { post '/api/v1/users/token', params: invalid_credentials, headers: headers }
      it 'returns a failure message' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

  end
  
  # create test user
  let!(:role) { create(:role) }
  let!(:user) { create(:user, roles: [role]) }
  # set headers for authorization
  let(:headers) { valid_headers }

  let(:valid_params) do
    password = Faker::Internet.password
    {current_password: user.password, password: password, password_confirmation: password}.to_json
  end

  let(:invalid_param_keys) do
    password = Faker::Internet.password
    {current_password: user.password, new_password: password, new_password_confirmation: password}.to_json  # param keys are not valid
  end

  let(:invalid_params) do
    {current_password: user.password, password: Faker::Internet.password, password_confirmation: Faker::Lorem.sentence}.to_json  # param keys are not valid
  end

  describe "POST /users/change_password" do
    context 'when request parameters are valid' do 
      before { post '/api/v1/users/change_password', params: valid_params, headers: headers }     
      it "returns success:true and successfully updates the record" do  
        expect(response).to be_successful
        resp = JSON.parse(response.body)
        expect(resp["success"]).to eq(true)
        user.reload
        password = JSON.parse(valid_params)["password"]
        expect(user.valid_password?(password)).to eq(true)
      end
    end
    
    context 'when request parameters are invalid' do 
      before { post '/api/v1/users/change_password', params: invalid_param_keys, headers: headers }
      it "returns bad request status" do  
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when password, password_confirmation are not same' do 
      before { post '/api/v1/users/change_password', params: invalid_params, headers: headers }
      it "returns bad request status" do  
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when token is missing' do  
      before { post '/api/v1/users/change_password', params: valid_params } #header is not sent
      it "returns a failure message" do  
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  let(:valid_change_email_params) do
    {email: Faker::Internet.email, password: user.password}.to_json
  end

  let(:invalid_change_email_params) do
    {email: Faker::Internet.email, password: Faker::Internet.password}.to_json
  end


  describe "POST /users/change_email" do
    context "when request parameters are valid" do
      before { post '/api/v1/users/change_email', params: valid_change_email_params, headers: headers }
      it "returns success:true and it successfully updated email" do  
        expect(response).to be_successful
        expect(JSON.parse(response.body)["success"]).to eq(true)
        user.reload
        expect(JSON.parse(valid_change_email_params)["email"]).to eq(user.email)
      end
    end

    context "when password is invalid" do
      before { post '/api/v1/users/change_email', params: invalid_change_email_params, headers: headers }
      it "returns unauthorized status code with message" do  
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "Forgot password" do
    context "when email exists" do
      before { get '/api/v1/users/forgot_password', params: {email: user.email} }
      it "sends email with reset token to the user if exists with given email" do
        expect(response).to be_successful
        expect(JSON.parse(response.body)["success"]).to eq(true) # success shows that the email for token has been sent 
      end
    end

    context "when email not exists" do
      before { get '/api/v1/users/forgot_password', params: {email: Faker::Internet.email} }
      it "returns status: record not found" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end


  describe "Reset password" do
    context "when valid token and credentials are given" do
      it "returns status:true and successfully updates password" do
        password = Faker::Internet.password
        post '/api/v1/users/reset_password', params: { reset_password_token: (generate_reset_token user), password: password, password_confirmation: password }
        
        expect(response).to be_successful
        expect(JSON.parse(response.body)["success"]).to eq(true)
        user.reload
        expect(user.valid_password?(password)).to eq(true)
      end
    end

    context "when invalid token is given" do
      password = Faker::Internet.password
      before { post '/api/v1/users/reset_password', params: { reset_password_token: "asasdasdasd", password: password, password_confirmation: password } }
      it "returns status bad request" do  
        expect(response).to have_http_status(:bad_request)
      end
    end

    context "when password and confirmation pasword is invalid" do
      before { post '/api/v1/users/reset_password', params: { reset_password_token: (generate_reset_token user), password: Faker::Internet.password, password_confirmation: Faker::Internet.password } }
      it "returns status bad request" do  
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe "Create user" do
    context "when valid parameters are given" do
      password = Faker::Internet.password
      email = Faker::Internet.email
      before { post '/api/v1/users', params: { username: Faker::Name.first_name, email: email, password: password, password_confirmation: password } }
      it "returns status:true and successfully create user" do    
        expect(response).to be_successful
        expect(JSON.parse(response.body)["success"]).to eq(true)
        expect(User.exists?(email: email)).to eq(true)
      end
    end

    context "when invalid parameters are given" do
      email = Faker::Internet.email
      before { post '/api/v1/users', params: { username: Faker::Name.first_name, email: email, password: Faker::Internet.password, password_confirmation: Faker::Internet.password } }
      it "returns status:false and error message" do  
        expect(response).to be_successful
        expect(JSON.parse(response.body)["success"]).to eq(false)
        expect(User.exists?(email: email)).to eq(false)
      end
    end
  end

end