class RenameColumnThirdSideToSideInFlashcardItems < ActiveRecord::Migration[5.1]
  def change
    rename_column :flashcard_items, :third_side, :side
  end
end
