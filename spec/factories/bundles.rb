FactoryBot.define do
  factory :bundle do
    title { Faker::Name.unique.name }
    description { Faker::Lorem.paragraph }
    allow_single_product_subscription { false }
    price { Faker::Number.decimal(2) }
    products { create_list(:product, 3).pluck(:id).map(&:to_s) }
  end
end
