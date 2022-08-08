FactoryBot.define do
  factory :content do
    title { Faker::Name.title }
    trait :with_type_modulee do
      # FactoryBot changed its syntax. It now expects a block when assigning values – even static values – to variables. Link: https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#defining-factories
      actable_type { "Modulee" }
      parent_id { nil }
      ancestry { nil }
      actable { FactoryBot.create(:modulee, configurations: {has_bookmarks: true, incorrect_answered_quiz: true}, product: product) }
    end

    trait :with_type_sub_modulee do
      actable_type { "Submodule" }
    end

    trait :with_type_quiz do
      actable_type { "Quiz" }
      actable { create_quiz }
      parent { FactoryBot.create(:content, :with_type_modulee, product: product) }
    end

    trait :with_type_flashcard do
      actable_type { "Flashcard" }
      actable { create_flashcard }
      parent { FactoryBot.create(:content, :with_type_modulee, product: product) }
    end

    trait :with_type_html do
      actable_type { "Html" }
    end

    product
  end

  factory :modulee do
    title { Faker::Name.title }
    configurations { { has_bookmarks: true, incorrect_answered_quiz: true } }
    product
  end

  factory :quiz do
    title { Faker::Name.title }
    product
  end

  factory :html do
    title { Faker::Name.title }
  end

  factory :flashcard do
    title { Faker::Name.title }
    product
  end
end

def modulee_with_children(type: 'quiz', child_count: 5)
  FactoryBot.create(:modulee) do |mod|
    FactoryBot.create_list(:content, child_count, "with_type_#{type}".to_sym)
  end
end

def create_quiz(items: 10)
  FactoryBot.create(:quiz) do |quiz|
    FactoryBot.create_list(:question, items, quiz: quiz)
  end
end

def create_flashcard(items: 10)
  FactoryBot.create(:flashcard) do |flashcard|
    FactoryBot.create_list(:flashcard_item, items, flashcard: flashcard)
  end
end

