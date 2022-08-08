class AddCompletedToQuizAttempts < ActiveRecord::Migration[5.1]
  def change
    add_column :quiz_attempts, :completed, :boolean
  end
end
