class FlashcardsController < ApplicationController
  include ContentsHelper
  before_action :set_flashcard, only: [:show, :viewedcontent]
  before_action :set_content, only: [:comprehensive, :comp_viewedcontent, :build, :build_viewedcontent, :build_continue]
  before_action :set_start, only: [:startover]
  before_action :set_breadcrumbs
  layout 'product'

  def show
    if @flashcard.present?
      @modulee = @flashcard.root.specific
      config = (get_configurations(@flashcard.content))
      @startover = config[:start_over] ? config[:start_over] : config[:startover]
      @has_bookmarks = config[:has_bookmarks]
      @bookmarks = @flashcard.content.bookmarks.where(user: current_user).pluck(:content_type_id)      
      @flashcard_items = @flashcard.flashcard_items
      @flashcard_items = @flashcard.flashcard_items.shuffle if @flashcard.shuffle

      @viewed = (find_contents @flashcard.content,'Flashcard', @flashcard.content.ancestry).last

      if @viewed.blank?
        @index = 0
      else
        viewed = @viewed.content_type_id.keys

        all = @flashcard_items.pluck("id").map(&:to_s)
        ordered = viewed + (all - viewed)
        @index = viewed.count == ordered.count ? 0 : viewed.count
        @flashcard_items = FlashcardItem.find(ordered)
      end
    end
  end

  def comprehensive
    content = Content.find(@content_id)
    @modulee = content.specific
    flashcards = @modulee.children.where(actable_type: 'Flashcard')
    @flashcard_items = []
    modulee = get_module_configurations content
    configurations = modulee[:configurations] if modulee.present?
    @has_bookmarks = configurations[:has_bookmarks]
    @bookmarks = Bookmark.where(user: current_user, content_type: 'FlashcardItem').pluck(:content_type_id) 

    flashcards.each do |flashcard|
      @flashcard_items.push(flashcard.specific.flashcard_items) if flashcard.specific.flashcard_items.present?
    end

    @flashcard_items = @flashcard_items.flatten 
    @viewed = (find_contents @content_id,'ComprehensiveFlashcard').last

    if @viewed.blank?
      @index = 0
    else
      viewed = @viewed.content_type_id.keys
      all = @flashcard_items.pluck("id").map(&:to_s)
      ordered = viewed + (all - viewed)
      @index = viewed.count == ordered.count ? 0 : viewed.count
      @flashcard_items = FlashcardItem.find(ordered)
    end

    render :show
  end

  def build viewed = nil
    if params.present?
      content = Content.find(@content_id)
      if params[:chapters].present? and params[:select].present?
        session[:chapters_for_built_flashcards] = params[:chapters]
        session[:no_of_flashcard_items] = params[:select]
        session[:flashcard_items] = nil
        viewed = (find_contents @content_id, 'BuildFlashcard')
        viewed.delete_all if viewed.present?
      end

      modulee = get_module_configurations content
      configurations = modulee[:configurations] if modulee.present?
      @has_bookmarks = configurations[:has_bookmarks]
      @bookmarks = Bookmark.where(user: current_user, content_type: 'FlashcardItem').pluck(:content_type_id) 


      chapters = session[:chapters_for_built_flashcards]
      no_of_items = session[:no_of_flashcard_items]
      contents = Content.find(chapters) if chapters.present?

      if session[:flashcard_items].present?
        @flashcard_items = FlashcardItem.find(session[:flashcard_items])
      else
        limit = no_of_items.to_i / contents.length unless no_of_items == 'All' and no_of_items.empty?
        @flashcard_items = []
        all_flashcard_items = []
        contents.each do |content|
          if no_of_items == "All"
            @flashcard_items.push(content.specific.flashcard_items.shuffle)
          else
            shuffled = content.specific.flashcard_items.shuffle
            taken = shuffled.take(limit)
            all_flashcard_items.push(shuffled - taken)
            @flashcard_items.push(taken)
          end
        end
        all_flashcard_items.flatten!
        @flashcard_items.flatten!
        
        remaining_limit = no_of_items.to_i - @flashcard_items.length unless no_of_items == "All" and @flashcard_items.empty?
        if remaining_limit.present? and remaining_limit > 0
          random_taken = all_flashcard_items.shuffle.take(remaining_limit)
          @flashcard_items.push(random_taken)
          @flashcard_items.flatten!
        end
        session[:flashcard_items] = @flashcard_items.pluck("id")
      end

      if viewed.blank?
        @index = 0
      else
        viewed = viewed.content_type_id.keys

        all = @flashcard_items.pluck("id").map(&:to_s)
        ordered = viewed + (all - viewed)
        @index = viewed.count == ordered.count ? 0 : viewed.count
        @flashcard_items = FlashcardItem.find(ordered)
      end
    
      render :show
    end
  end

  def build_continue
    if session[:chapters_for_built_flashcards].present?
      limit = session[:no_of_flashcard_items]
      viewed = (find_contents @content_id, 'BuildFlashcard').last
      build viewed
    end
  end

  def bookmark
    success = false

    return if !current_user

    if params[:destroy] == 'true'
      bkm = Bookmark.where(user: current_user, content_type_id: params[:flashcarditem])
      success = bkm.first.destroy ? true : false if bkm.present?
    
    elsif params[:flashcarditem].present? 
      item = FlashcardItem.find(params[:flashcarditem])
      success = true if item.present? and Bookmark.find_or_create_by(user: current_user, content: item.flashcard.content, content_type: "FlashcardItem", content_type_id: params[:flashcarditem])
    end
    
    render json: { success: success }
  end


  def startover 
    return if !current_user
      
    if @flashcard
      data = find_contents @flashcard.content,'Flashcard', @flashcard.content.ancestry
      data.delete_all if data.present?
      redirect_to flashcard_path  content
    elsif @content_id
      data = find_contents @content_id,'ComprehensiveFlashcard'
      data.delete_all if data.present?
      redirect_to comprehensive_flashcards_path
    end  
     
  end


  def comp_viewedcontent
    success = false

    return if !current_user

    data = ViewedContent.find_or_create_by(user: current_user, content_id: @content_id, content_type: "ComprehensiveFlashcard")
    
    if params[:flashcarditem].present? and params[:status].present?
      data.content_type_id = {} if data.completed
      data.content_type_id[params[:flashcarditem]] = nil
      data.completed = params[:status]
      data.save
    end

    success = true

    render json: { success: success }
  end

  def build_viewedcontent
    success = false

    return if !current_user

    data = ViewedContent.find_or_create_by(user: current_user, content_id: @content_id, content_type: "BuildFlashcard")
    
    if params[:flashcarditem].present? and params[:status].present?
      data.content_type_id = {} if data.completed
      data.content_type_id[params[:flashcarditem]] = nil
      data.completed = params[:status]
      data.save
    end

    success = true

    render json: { success: success }
  end

  def viewedcontent
    success = false

    return if !current_user.present?
    #TODO: Actable Id is saved in Place of Ancestor Id (i.e Modulee for Flashcard), which is wrong... needed to be fixed
    data = current_user.viewed_contents.find_or_create_by(content: @flashcard.content, content_type: "Flashcard", ancestry: @flashcard.content.ancestry)

    if params[:flashcarditem].present? and params[:status].present?
      data.content_type_id = {} if data.completed
      data.content_type_id[params[:flashcarditem]] = nil
      data.completed = params[:status]
      data.save
   
    end

    success = true

    render json: { success: success }
  end

  def audit
    if params[:id].present?
      @audit_id  = params[:id] 
      @modulee =  Content.find(params[:id]).specific
      
      product = Product.find(@modulee.product.id)
      @flashcard_items = []
      modulee = get_module_configurations @modulee.content if @modulee.present?
      configurations = modulee[:configurations]
      flashcards_count = configurations[:auditable_flashcards_limit].to_i if configurations.present?
      flashcards = @modulee.children.where(actable_type: 'Flashcard') if @modulee.present?

      

      flashcards.each do |flashcard|
        count = flashcard.specific.flashcard_items.count
        
        if flashcards_count <= count
          @flashcard_items.push(flashcard.specific.flashcard_items.limit(flashcards_count)) if flashcard.specific.flashcard_items.present? 
          break
        else
          @flashcard_items.push(flashcard.specific.flashcard_items.limit(count)) if flashcard.specific.flashcard_items.present?
          flashcards_count = flashcards_count - count    
        end
      end


      @flashcard_items = @flashcard_items.flatten
      @index = 0
    end

    render :show
  end  



  private
    
    def set_start
      if params[:content_id]
        @content_id = params[:content_id]
      elsif params[:id]
        @flashcard = Flashcard.find(params[:id])
      end  
    end  

    def set_content
      @content_id = params[:content_id]
    end

    def set_flashcard
      @flashcard = Flashcard.find(params[:id])
    end

    def set_breadcrumbs
      add_breadcrumb "Home", dashboard_path

      if @flashcard.present?
        add_breadcrumb @flashcard.parent.product.title, product_path(@flashcard.parent.product)
        add_breadcrumb @flashcard.parent.title, content_path(@flashcard.parent)
        add_breadcrumb @flashcard.title, flashcard_path(@flashcard)
      else
        content_id = params[:content_id]

        if content_id.present?
          product = Content.find(content_id).product
          add_breadcrumb product.title, product_path(product)
        end
      end
    end

    def find_contents content_id, content_type, ancestry=nil
      ViewedContent.where(user: current_user, content: content_id, content_type: content_type, ancestry: ancestry)
    end
end
