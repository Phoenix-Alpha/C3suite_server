FactoryBot.define do

  factory :product do
    title { Faker::Name.unique.name }
    icon { nil }
    html_description { Faker::Lorem.paragraph }
    price { Faker::Number.decimal(2) }
    visibility { "All" }
    background { nil }
    app_store_bundle_id { "com.test.app" }
    
    before(:create) do |product|
      product.product_assets << FactoryBot.build_list(:product_asset, 1, product: product)
      product.contents << FactoryBot.build_list(:content, 3, :with_type_modulee, product: product)
      # product.contents << FactoryBot.build_list(:content, 5, :with_type_quiz, product: product)
    end
  end

end
