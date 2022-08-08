FactoryBot.define do
  factory :user do
    username { 'testuser' }
    email { "uzair@emerssive.com" }
    password  { "code3apps" }
    password_confirmation { "code3apps" }
  end
end
