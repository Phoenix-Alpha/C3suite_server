class AddThirdSideToFlashcardItems < ActiveRecord::Migration[5.1]
  def change
    add_column :flashcard_items, :third_side, :string
  end
end
