class AddRowOrderToFlashcardItems < ActiveRecord::Migration[5.1]
  def change
    add_column :flashcard_items, :row_order, :integer
  end
end
