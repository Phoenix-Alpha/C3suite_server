class Modulee < ApplicationRecord
  acts_as :content
  validates_numericality_of :time_limit, :greater_than_or_equal_to => 0, allow_nil: true
  serialize :comprehensive_questions, Array
  serialize :flashcard_labels, Hash 
  serialize :configurations, Hash
  
  def has_bookmarks?
    has_bookmarks
  end

  def has_quizzes?
    !new_record? && children.where(actable_type: 'Quiz').present?
  end

  def has_flashcards?
    !new_record? && children.where(actable_type: 'Flashcard').present?
  end

  def has_htmls?
    !new_record? && children.where(actable_type: 'Html').present?
  end

  def has_media?
    !new_record? && children.where(actable_type: 'Media').present?
  end

  def has_children_type? type
    !new_record? && children.where(actable_type: type).present?
  end

  def bookmarks_submodule
    children.where(title: "Bookmarks").first
  end
end
