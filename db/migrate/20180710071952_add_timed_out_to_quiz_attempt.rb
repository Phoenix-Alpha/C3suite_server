class AddTimedOutToQuizAttempt < ActiveRecord::Migration[5.1]
  def change
    add_column :quiz_attempts, :timed_out, :boolean, :default => false
  end
end
