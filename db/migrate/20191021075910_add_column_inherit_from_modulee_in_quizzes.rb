class AddColumnInheritFromModuleeInQuizzes < ActiveRecord::Migration[5.2]
  def change
    add_column :quizzes, :inherit_modulee_configs, :boolean, default: true
  end
end
