class AddColumnHasComprehensiveQuizToModulees < ActiveRecord::Migration[5.1]
  def change
    add_column :modulees, :allow_comprehensive_quizzes, :boolean
    add_column :modulees, :allow_compresive_flashcards, :boolean
  end
end
