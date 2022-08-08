class AddSkippableInQuiz < ActiveRecord::Migration[5.1]
  def change
    add_column :quizzes, :skippable, :boolean
  end
end
