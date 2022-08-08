class AddColumnHasComprehensiveQuizAndFlashcardToModulees < ActiveRecord::Migration[5.1]
  def change
    remove_column :modulees, :allow_comprehensive_quiz, :boolean if column_exists? :modulees, :allow_comprehensive_quiz
    add_column :modulees, :allow_comprehensive_quizzes, :boolean unless column_exists? :modulees, :allow_comprehensive_quizzes
    add_column :modulees, :allow_comprehensive_flashcards, :boolean unless column_exists? :modulees, :allow_comprehensive_flashcards
  end
end
