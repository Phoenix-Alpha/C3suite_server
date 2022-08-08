class AddColumnsToQuiz < ActiveRecord::Migration[5.1]
  def change
    add_column :quizzes, :type, :string
    add_column :quizzes, :time, :integer
    add_column :quizzes, :row_order, :integer
  end
end
