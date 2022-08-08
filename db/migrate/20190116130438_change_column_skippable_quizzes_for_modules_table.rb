class ChangeColumnSkippableQuizzesForModulesTable < ActiveRecord::Migration[5.1]
  def change
    remove_column :modulees, :skippable_quizzes if column_exists? :modulees, :skippable_quizzes, :text
    add_column :modulees, :setting_skip_quiz, :boolean, null: false, default: false
  end
end
