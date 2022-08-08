class AddColumnFlashcardLabelsToModulee < ActiveRecord::Migration[5.1]
  def change
    add_column :modulees, :flashcard_labels, :text
  end
end
