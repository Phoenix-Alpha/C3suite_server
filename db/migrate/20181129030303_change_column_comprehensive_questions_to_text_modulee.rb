class ChangeColumnComprehensiveQuestionsToTextModulee < ActiveRecord::Migration[5.1]
  def change
    change_column :modulees, :comprehensive_questions, :text, array: true
  end
end
