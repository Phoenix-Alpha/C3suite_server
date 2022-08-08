# spec/acceptance/residences_spec.rb
require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Users' do

  let!(:role) { create(:role) }
  let!(:user) { create(:user, roles: [role]) }
  # set headers for authorization
  let(:headers) { valid_headers.except('Authorization') }
  # set test valid and invalid credentials

  post 'api/v1/users/token' do
    parameter :email, "Email"
    parameter :password, "Password"

    let(:email) { user.email }
    let(:password) { user.password }

    example 'Get an auth token' do
      explanation "Use this endpoint to get a JWT token for authentication."

      do_request

      expect(status).to eq(200)
    end
  end

  post 'api/v1/users' do
    parameter :username, "Username"
    parameter :email, "Email"
    parameter :password, "Password"
    parameter :confirmation_password, "Confirmation Password"
    
    let(:username) { Faker::Name.first_name }
    let(:email) { Faker::Internet.email }
    let(:password) { Faker::Internet.password }
    let(:confirmation_password) { password }


    example 'Create a user' do
      explanation "Use this endpoint to create a new user."
      
      do_request

      expect(status).to eq(200)
    end
  end
  
  let(:email) { user.email }
  get 'api/v1/users/forgot_password' do
    parameter :email, "User email"
    
    example 'Forgot password' do
      explanation "Use this endpoint to send password reset email to the user."
      
      do_request
      
      expect(status).to eq(200)
      expect(JSON.parse(response_body)["success"]).to eq(true)
    end
  end

  post 'api/v1/users/reset_password' do

    let(:reset_password_token) { generate_reset_token user  }
    let(:password) { Faker::Internet.password }
    let(:confirmation_password) { password }

    parameter :reset_password_token, "Password reset token obtained from email"
    parameter :password, "New Password"
    parameter :password_confirmation, "New password confirmation"
    
    example 'Reset password' do
      explanation "Use this endpoint to reset password."
      do_request
      
      expect(status).to eq(200)
      expect(JSON.parse(response_body)["success"]).to eq(true)
    end
  end

  header "Authorization", :authorization
  let(:authorization) { token_generator(user.id) }
    

  post 'api/v1/users/change_email' do
    let(:email) { Faker::Internet.email }
    let(:password) { user.password }

    parameter :email, "New email address to be updated"
    parameter :password, "User's current password"

    example 'Change user email' do
      explanation "Use this endpoint to change user email."
      
      do_request

      expect(status).to eq(200)
      expect(JSON.parse(response_body)["success"]).to eq(true)
    end
  end


  post 'api/v1/users/change_password' do
    let(:current_password) { user.password }
    let(:password) { Faker::Internet.password }
    let(:confirmation_password) { password }

    parameter :current_password, "User's current password"
    parameter :password, "New password"
    parameter :confirmation_password, "New password confirmation"

    example 'Change User Password' do
      explanation "Use this endpoint to change user password."
      
      do_request

      expect(status).to eq(200)
      expect(JSON.parse(response_body)["success"]).to eq(true)
    end
  end
end