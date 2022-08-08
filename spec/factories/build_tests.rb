FactoryBot.define do
  factory :build_test do
    user { nil }
    chapter_ids { [] }
    content_type { "Quiz" }
    no_of_items { "25" }
    content { nil }
    content_type_ids { [] }
  end
end
