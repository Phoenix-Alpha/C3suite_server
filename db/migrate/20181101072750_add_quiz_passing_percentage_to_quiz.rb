class AddQuizPassingPercentageToQuiz < ActiveRecord::Migration[5.1]
  def change
    add_column :quizzes, :passing_percentage, :integer
  end
end
