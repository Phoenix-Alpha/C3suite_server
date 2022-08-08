class HtmlsController < ApplicationController
  include ProductsHelper
  before_action :set_html
  before_action :set_breadcrumbs, only: [:show, :bookmark]
  layout 'product'

  def show
    if @html.present?
      product_id = @html.parent.product_id
      @modulee = @html.root.specific
      @is_subscribed_product = current_user.present? and is_subscribed product_id.present?
      
      @bookmarks = @html.content.bookmarks.where(user: current_user).pluck(:content_type_id)
      @viewed = find_contents @html.content, 'Html', @html.id, 'true'
      @viewed = @viewed.present? ? true : false
         
    end
  end

  def bookmark
    success = false

    return if !current_user

    if params[:destroy] == 'true'
      bkm = Bookmark.where(user: current_user, content_type_id: params[:html])
      bkm.first.destroy if bkm.present?

      success = true
    
    elsif params[:html].present? && Bookmark.find_or_create_by(user: current_user, content: @html.content, content_type: "Html", content_type_id: params[:html])
      success = true
    end
    
    render json: { success: success }
  end

  def viewedcontent
    success = false
    return if !current_user
    data = ViewedContent.find_or_create_by(user: current_user, content: @html.content, content_type: "Html", ancestry: @html.content.actable_id)
    
    if params[:status].present?
      data.completed = params[:status]
    end
    data.save
    success = true
    render json: { success: success }
  end

  private
    def set_html
      @html = Html.find(params[:id])
    end

    def find_contents content, content_type, ancestry, completed
      ViewedContent.where(user: current_user, content: content, content_type: content_type, ancestry: ancestry, completed: completed)
    end

    def set_breadcrumbs
      add_breadcrumb "Home", dashboard_path
      add_breadcrumb @html.parent.product.title, product_path(@html.parent.product)
      add_breadcrumb @html.parent.title, content_path(@html.parent)
      add_breadcrumb @html.title, html_path(@html)
    end

end
