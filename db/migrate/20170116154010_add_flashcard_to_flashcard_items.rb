class AddFlashcardToFlashcardItems < ActiveRecord::Migration[5.1]
  def change
    add_reference :flashcard_items, :flashcard, foreign_key: true
  end
end
