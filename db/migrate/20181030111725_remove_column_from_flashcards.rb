class RemoveColumnFromFlashcards < ActiveRecord::Migration[5.1]
  def change
    remove_column :modulees, :allow_compresive_flashcards, :boolean if column_exists? :modulees, :allow_compresive_flashcards
  end
end
