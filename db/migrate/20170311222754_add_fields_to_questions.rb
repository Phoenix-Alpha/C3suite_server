class AddFieldsToQuestions < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :question, :text
    add_column :questions, :correct, :text
    add_column :questions, :distractor1, :text
    add_column :questions, :distractor2, :text
    add_column :questions, :distractor3, :text
    add_column :questions, :distractor4, :text
    add_column :questions, :distractor5, :text
    add_column :questions, :distractor6, :text
    add_column :questions, :distractor7, :text
    add_column :questions, :distractor8, :text
    add_column :questions, :distractor9, :text
  end
end
