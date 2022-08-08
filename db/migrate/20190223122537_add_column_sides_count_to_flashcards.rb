class AddColumnSidesCountToFlashcards < ActiveRecord::Migration[5.1]
  def change
    add_column :flashcards, :sides_count, :string, default: "2"
  end
end
