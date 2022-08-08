class RemoveColumnFlashcardLabelsFromModulee < ActiveRecord::Migration[5.1]
  def change
    remove_column :modulees, :flashcard_labels
  end
end
