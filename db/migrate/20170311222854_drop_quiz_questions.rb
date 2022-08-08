class DropQuizQuestions < ActiveRecord::Migration[5.1]
  def change
    drop_table :quiz_questions if data_source_exists?(:quiz_questions)
  end
end
