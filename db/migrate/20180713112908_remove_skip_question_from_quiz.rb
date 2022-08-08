class RemoveSkipQuestionFromQuiz < ActiveRecord::Migration[5.1]
  def change
    remove_column :quizzes, :skip_question, :boolean
  end
end
