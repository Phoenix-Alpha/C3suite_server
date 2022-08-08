FactoryBot.define do
  factory :question do
    hint { Faker::Lorem.sentence(6) }
    explanation { Faker::Lorem.sentence(5) }
    correct { Faker::Lorem.sentence(4) }
    distractor1 { Faker::Lorem.sentence(3) }
    distractor2 { Faker::Lorem.sentence(2) }
    distractor3 { Faker::Lorem.sentence(1) }
    quiz
  end
end
