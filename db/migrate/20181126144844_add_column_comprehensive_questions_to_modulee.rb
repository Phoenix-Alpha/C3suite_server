class AddColumnComprehensiveQuestionsToModulee < ActiveRecord::Migration[5.1]
  def change
    add_column :modulees, :comprehensive_questions, :text , array: true
  end
end
