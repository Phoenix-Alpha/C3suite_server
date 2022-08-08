class BookmarksController < ApplicationController
  include BookmarksHelper
  load_and_authorize_resource :bookmarks
  before_action :set_product, only: [:show]
  before_action :set_bookmark, only: [:show]
  before_action :set_breadcrumbs
  layout 'product'


  def index
    @q_bkms = bkms_of_type 'Question'
    @f_bkms = bkms_of_type 'FlashcardItem'
    @h_bkms = bkms_of_type 'Html'
    @m_bkms = bkms_of_type 'Media'
  end

  def show
    bkms = bookmarks_order Bookmark.where(user: current_user)
    unless (@bookmark.content_type == 'Html' or @bookmark.content_type == 'Media')
      @collection = []

      bkms.each do |bkm|
        next unless bkm.content.present? && bkm.content.product.present?

        if bkm.content.product.id == @product.id && bkm.content_type == @bookmark.content_type
          @collection.push(bkmed_content bkm)
        end
      end
    end
  end

  private

  def set_bookmark
    @bookmark = Bookmark.find(params[:id])
  end

  def set_product
    @product = Product.friendly.find(params[:product_id])
  end

  def bkms_of_type type
    @bkm = current_user.bookmarks.where(content_type: type)
    @bkm.each do |b|
      if type.constantize.where(id: b.content_type_id).empty?
        Bookmark.destroy(b.id)        
      end
    end
    @bkm = current_user.bookmarks.where(content_type: type)
  end

  def bkmed_content bkm
    "" if bkm.nil? || bkm.content_type.nil? || bkm.content_type_id.nil?

    type = bkm.content_type
    type.constantize.find(bkm.content_type_id)
  end

  def set_breadcrumbs
    add_breadcrumb "Home", dashboard_path
    add_breadcrumb 'Bookmarks', bookmarks_url
  end
end
