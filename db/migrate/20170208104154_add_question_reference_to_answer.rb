class AddQuestionReferenceToAnswer < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :answers, :questions, column: :question_id
  end
end
