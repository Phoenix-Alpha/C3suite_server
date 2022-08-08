class AddColumnCorrectToAnswers < ActiveRecord::Migration[5.1]
  def change
    add_column :answers, :correct, :boolean
  end
end
