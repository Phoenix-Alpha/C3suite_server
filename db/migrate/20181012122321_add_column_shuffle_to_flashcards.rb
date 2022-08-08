class AddColumnShuffleToFlashcards < ActiveRecord::Migration[5.1]
  def change
    add_column :flashcards, :shuffle, :boolean
  end
end
