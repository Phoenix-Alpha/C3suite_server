class RemoveColumnFlashcardAttachmentSideFromModulee < ActiveRecord::Migration[5.1]
  def change
    remove_column :modulees, :flashcard_attachment_side
  end
end
