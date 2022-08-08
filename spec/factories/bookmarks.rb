FactoryBot.define do
  factory :bookmark do
    user nil
    content nil
    content_type { "Question" }
    content_type_id { 1 }
  end
end
