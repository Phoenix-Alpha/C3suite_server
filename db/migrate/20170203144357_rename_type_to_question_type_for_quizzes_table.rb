class RenameTypeToQuestionTypeForQuizzesTable < ActiveRecord::Migration[5.1]
  def change
    rename_column :quizzes, :type, :q_type
  end
end
