class DropTableQuizAttempt < ActiveRecord::Migration[5.1]
  def change
    drop_table :quiz_attempts
  end
end
