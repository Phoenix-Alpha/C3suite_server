FactoryBot.define do
  factory :flashcard_item do
    front { Faker::Lorem.sentence }
    back { Faker::Lorem.sentence }
  end
end
