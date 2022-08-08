class MediaController < ApplicationController
  include ContentsHelper
  before_action :set_media
  before_action :set_breadcrumbs, only: [:show, :bookmark]

  layout 'product'

  def show
    if @media.present?
      config = (get_configurations(@media.content))
      @has_bookmarks = config[:has_bookmarks]
      @bookmarks = @media.content.bookmarks.where(user: current_user).pluck(:content_type_id)      
      @viewed = find_contents @media.content, 'Media', @media.id, 'true'
      @viewed = @viewed.present? ? true : false
    end

  end

  def viewedcontent
    success = false
    return if !current_user
    data = ViewedContent.find_or_create_by(user: current_user, content: @media.content, content_type: "Media", ancestry: @media.content.actable_id)
    
    if params[:status].present?
      data.completed = params[:status]
    end
    data.save
    success = true
    render json: { success: success }
  end

  def bookmark
    success = false

    return if !current_user

    if params[:destroy] == 'true'
      bkm = Bookmark.where(user: current_user, content_type_id: params[:media])
      bkm.first.destroy if bkm.present?

      success = true
    
    elsif params[:media].present? && Bookmark.find_or_create_by(user: current_user, content: @media.content, content_type: "Media", content_type_id: params[:media])
      success = true
    end
    
    render json: { success: success }
  end

  private
    def set_media
      @media = Media.find(params[:id])
    end

    def find_contents content, content_type, ancestry, completed
      ViewedContent.where(user: current_user, content: content, content_type: content_type, ancestry: ancestry, completed: completed)
    end

    def set_breadcrumbs
      add_breadcrumb "Home", dashboard_path
      add_breadcrumb @media.parent.product.title, product_path(@media.parent.product)
      add_breadcrumb @media.parent.title, content_path(@media.parent)
      add_breadcrumb @media.title, media_path(@media)
    end
end
