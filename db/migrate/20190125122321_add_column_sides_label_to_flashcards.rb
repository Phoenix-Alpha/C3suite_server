class AddColumnSidesLabelToFlashcards < ActiveRecord::Migration[5.1]
  def change
    add_column :flashcards, :sides_label, :text
  end
end
