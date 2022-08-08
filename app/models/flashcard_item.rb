class FlashcardItem < ApplicationRecord
  include AttachmentUploader[:side]
  belongs_to :flashcard

  include RankedModel
  ranks :row_order, class_name: 'FlashcardItem'

  def content
    flashcard.content
  end
end
