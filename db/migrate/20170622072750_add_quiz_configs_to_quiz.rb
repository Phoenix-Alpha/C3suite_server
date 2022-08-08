class AddQuizConfigsToQuiz < ActiveRecord::Migration[5.1]
  def change
    add_column :quizzes, :shuffle, :boolean
    add_column :quizzes, :back_navigation, :boolean
    rename_column :quizzes, :time, :time_limit
  end
end
