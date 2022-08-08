class AddRemoveColumnsToMiscTables < ActiveRecord::Migration[5.1]
  def change
    # Remove Columns
    remove_column :modulees, :name
    remove_column :quizzes, :name
    remove_column :flashcards, :name
    remove_column :htmls, :name

    # Add Columns
    add_column :contents, :name, :string
    add_column :contents, :view_count, :integer
    
    add_column :htmls, :has_plain_text, :boolean
  end
end
