class AddColumnFlashcardAttachmentSideToModulee < ActiveRecord::Migration[5.1]
  def change
    add_column :modulees, :flashcard_attachment_side, :string
  end
end
