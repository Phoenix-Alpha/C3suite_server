class FlashcardItemSerializer < ActiveModel::Serializer
  attributes :id, :front, :back, :side, :attachment_side, :front_label, :back_label, :side_label, :sides_count, :flashcard_id

  def front
    if self.object.flashcard.attachment_side == 'front'
      self.object.side_url :front
    else
      self.object.front
    end
  end

  def back
    attachment_side = self.object.flashcard.attachment_side
    if attachment_side == 'front'
      self.object.front
    elsif attachment_side == 'back'
      self.object.side_url :back
    else
      self.object.back
    end
  end

  def side
    if self.object.flashcard.attachment_side != 'side'
      self.object.back
    else
      self.object.side_url
    end
  end

  def attachment_side
      self.object.flashcard.attachment_side
  end

  def front_label
    self.object.flashcard.sides_label[:front]
  end

  def back_label
    self.object.flashcard.sides_label[:back]
  end

  def side_label
    self.object.flashcard.sides_label[:side]
  end

  def sides_count
    self.object.flashcard.sides_count
  end

  def flashcard_id
    self.object.flashcard_id
  end
end
