class AddColumnInheritFromModuleeInFlashcards < ActiveRecord::Migration[5.2]
  def change
    add_column :flashcards, :inherit_modulee_configs, :boolean, default: true
  end
end
