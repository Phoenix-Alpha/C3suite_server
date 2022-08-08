FactoryBot.define do
  factory :content_asset do
    description { Faker::Lorem.sentence }
    uri { Faker::LoremPixel.image }
    kind { Faker::Number.decimal(2) }
    # Not using Faker's image since its response time is high
    # remote_uri_url { Faker::LoremPixel.image }
    remote_uri_url { "https://fakeimg.pl/300/" }
    active { true }

    product
  end
end
