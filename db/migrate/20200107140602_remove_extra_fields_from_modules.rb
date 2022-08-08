class RemoveExtraFieldsFromModules < ActiveRecord::Migration[5.2]
  def change
    remove_column :modulees, :has_bookmarks if column_exists?(:modulees, :has_bookmarks)
    remove_column :modulees, :allow_comprehensive_quizzes if column_exists?(:modulees, :allow_comprehensive_quizzes)
    remove_column :modulees, :allow_comprehensive_flashcards if column_exists?(:modulees, :allow_comprehensive_flashcards)
    remove_column :modulees, :comprehensive_questions if column_exists?(:modulees, :comprehensive_questions)
    remove_column :modulees, :auditable if column_exists?(:modulees, :auditable)
    remove_column :modulees, :setting_skip_quiz if column_exists?(:modulees, :setting_skip_quiz)
    remove_column :modulees, :comprehensive_flashcards if column_exists?(:modulees, :comprehensive_flashcards)
  end
end
