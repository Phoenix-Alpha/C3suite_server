module BookmarksHelper
  include Flashcard::FlashcardsHelper

  def content_title bookmark
    bookmark.content.title unless bookmark.content_type == 'HTML'
  end

  def bookmarked_item_title bookmark
    "" if bookmark.nil? || bookmark.content_type.nil? || bookmark.content_type_id.nil?

    type = bookmark.content_type
    col = type == 'Question' ? :question : type == 'FlashcardItem' ? :front : :title
    content = type.constantize.where(id: bookmark.content_type_id)
    if content.present?
      col == :title ? ((bookmark.content.description).nil? ? content.first[col] : bookmark.content.description) : content.first[col]
    end
  end
  
  def bookmark_item_url bookmark
    type = bookmark.content_type
    prefix = type == 'Question' ? :quizzes : type == 'FlashcardItem' ? :flashcards : type == 'Html' ? :htmls : :media

    "/#{prefix}/bookmark"
  end

  def unbookmark_link bookmark
    type = bookmark.content_type
    id = type == 'Question' ? :question_id : type == 'FlashcardItem' ? :flashcarditem_id : type == 'Html' ? :html_id : :media_id
    btn_cls = type == 'Question' ? 'btn-bkmark-quiz' : (type == 'FlashcardItem' ? 'btn-bkmark-flashcard' : (type == 'Html' ? 'btn-bkmark-html' : 'btn-bkmark-media'))
    
    data = { id => bookmark.content_type_id }

    content_tag :span, "<span class='fa-fw fas fa-heart mr-2'></span>".html_safe, class: "bookmark #{btn_cls} bookmarked float-left", data: data, title: 'Click to unbookmark'
  end

  def bookmarks_order bookmark
    bookmark.order("CASE id WHEN #{@bookmark.id} THEN 0 ELSE 1 END") if @bookmark.present?
  end

  def get_product_bookmarks list, product_id
    if list.present? && product_id.present?
      bkms = list.map { |b| b if b.content.product_id == product_id }.compact
      bkms.group_by(&:content_id) if bkms.present?
      
    end 
  end  

end
