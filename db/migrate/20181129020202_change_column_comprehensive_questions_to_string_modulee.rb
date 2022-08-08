class ChangeColumnComprehensiveQuestionsToStringModulee < ActiveRecord::Migration[5.1]
  def change
    change_column :modulees, :comprehensive_questions, :string
  end
end
