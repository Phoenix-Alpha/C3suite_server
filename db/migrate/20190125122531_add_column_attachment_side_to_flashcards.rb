class AddColumnAttachmentSideToFlashcards < ActiveRecord::Migration[5.1]
  def change
    add_column :flashcards, :attachment_side, :string
  end
end
