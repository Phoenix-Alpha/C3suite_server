class RemoveColumnIsComprehensiveFromQuizzesFlashcards < ActiveRecord::Migration[5.1]
  def change
    remove_column :quizzes, :is_comprehensive, :boolean
    remove_column :flashcards, :is_comprehensive, :boolean
  end
end
