class AddComprehensiveConfigToQuizzesAndFlashcards < ActiveRecord::Migration[5.1]
  def change
    add_column :quizzes, :is_comprehensive, :boolean
    add_column :flashcards, :is_comprehensive, :boolean
  end
end
