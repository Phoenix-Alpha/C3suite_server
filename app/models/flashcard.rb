class Flashcard < ApplicationRecord
  acts_as :content

  has_many :flashcard_items, dependent: :destroy
  accepts_nested_attributes_for :flashcard_items, reject_if: :all_blank, allow_destroy: true

  serialize :sides_label, Hash 
  def items
    flashcard_items
  end

  def save_with_nested_attributes(flashcard_items_attributes)
    flashcard_items_objects = []

    transaction do
      save!
      flashcard_items_attributes.each do |flashcard_item_attributes|
        flashcard_item = FlashcardItem.new(flashcard_item_attributes)
        flashcard_item.flashcard_id = self.id
        flashcard_items_objects << flashcard_item
      end

      FlashcardItem.import flashcard_items_objects
    end
  end
end
