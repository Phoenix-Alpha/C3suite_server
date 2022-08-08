class CreateIncorrectQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :incorrect_questions do |t|
      t.references :user, foreign_key: true
      t.references :content, foreign_key: true
      t.integer :content_type_id

      t.timestamps
    end
  end
end
