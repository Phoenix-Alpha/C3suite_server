class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :content

  def item
    content_type.constantize.find(content_type_id)
  end

  def thumb
    content.image('square') if content.present?
  end
end
