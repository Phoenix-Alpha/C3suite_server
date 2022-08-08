FactoryBot.define do
  factory :bundle_asset do
    description { "MyString" }
    product_id { "" }
    kind { 1 }
    active { false }
    source_data { "MyText" }
  end
end
