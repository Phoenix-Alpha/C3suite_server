class ContentsController < ApplicationController
  include ContentsHelper
  include ProductsHelper

  before_action :set_content, only: [:show, :show_build_a_quiz, :show_build_a_flashcard]
  before_action :set_breadcrumbs, only: [:show, :show_build_a_quiz, :show_build_a_flashcard]
  layout 'product/dashboard'

  def show
    config = get_module_configurations @content
    redirect_to '/', notice: 'Access restricted for this content.' unless (can? :read, @content or (config.present? and config[:configurations].present? and config[:configurations][:auditable]))
    @product = Product.find(@content.product_id)
    session[:selected] = @content.title
  end

  def show_build_a_quiz
    @viewed  = ViewedContent.where(user: current_user, content: @content.id, content_type: 'BuildQuiz', completed: false)
    @product = Product.find(@content.product_id)
  end

  def show_build_a_flashcard
    @viewed  = ViewedContent.where(user: current_user, content: @content.id, content_type: 'BuildFlashcard', completed: false)
    @product = Product.find(@content.product_id)
  end

  private
    def set_content
      @content = Content.find(params[:id])
    end

    def set_breadcrumbs
      if @content.nil?
        @content = Content.find(params[:id])
      end
      add_breadcrumb "Home", dashboard_path
      add_breadcrumb @content.product.title, product_path(@content.product)
      add_breadcrumb @content.title, content_path(@content)
    end
end
