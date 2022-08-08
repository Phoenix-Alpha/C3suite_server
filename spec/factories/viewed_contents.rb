FactoryBot.define do
  factory :viewed_content do
    user nil
    content nil
    completed { false }
  end
end
