class AddStartOverToQuiz < ActiveRecord::Migration[5.1]
  def change
    add_column :quizzes, :start_over, :boolean
  end
end
