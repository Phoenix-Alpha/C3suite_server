class Manage::FlashcardsController < Manage::BaseController
  include FileUpload
  include FlashcardsHelper
  
  before_action :set_content, except: [:destroy]
  load_and_authorize_resource :product

  def show
    @flashcard_items = @flashcard.items
  end

  def new
  end
  
  def edit
  end
 

  def create
    if @flashcard.save
      redirect_to edit_manage_product_flashcard_url(@product, @flashcard), notice: 'Flashcard Content was successfully created'
    else
      # persist content if the form validation fails
      @content ||= Content.find(flashcard_params[:parent_id].to_i) if flashcard_params[:parent_id].present?
      
      render action: :new
    end
  end

  def update_flashcard_labels
    if params.present? && params[:sides_count].present?
      if params[:sides_count] == "3"
        order = (flashcard_items_order params[:attachment_side]) if params[:attachment_side].present? 
        @flashcard.sides_label = { front: order[0] , back: order[1] , side: order[2] } if params[:front].present? or params[:back].present? or params[:side].present?
        @flashcard.attachment_side = params[:attachment_side] if params[:attachment_side].present?
      
      elsif params[:sides_count] == "2"
        @flashcard.sides_label = { front: (params[:front] if params[:front].present?), back: (params[:back] if params[:back].present?), side: (params[:side] if params[:side].present?) } 
      end
      @flashcard.sides_count = params[:sides_count]
      @flashcard.save
    end

    redirect_to edit_manage_product_flashcard_url(@product, @flashcard) 
  end 

  def flashcards_setting 
  end  

  def update 
    if @flashcard.update(flashcard_params)
      redirect_to manage_product_flashcard_url(@product, @flashcard), notice: 'Flashcard Content was successfully updated.'
    else
      render action: :edit
    end
  end

  def destroy
    @flashcard.destroy
    redirect_to manage_product_url(@product), notice: 'Flashcard was successfully destroyed.'
  end

  def update_flashcard_item_position
    # TODO: Not cool, do something about the following 2 lines of code.
    flashcard_item = flashcard_params[:flashcard_items_attributes].first if flashcard_params[:flashcard_items_attributes].present?
    flashcard_item = flashcard_item[1] if flashcard_item.present?

    if flashcard_item.present? && flashcard_item[:id].to_i > 0
      fitem = FlashcardItem.find(flashcard_item[:id])
      fitem.row_order_position = flashcard_item[:row_order_position]
      fitem.save
    end

    head :ok
  end

  private
  def set_content
    @content ||= Content.find(params[:content_id]) if params[:content_id].present?
  end

  def flashcard_params
    params.require(:flashcard).permit(:title, :description, :shuffle, :sides_count, :parent_id, :inherit_modulee_configs, :product_id, flashcard_items_attributes: [:id, :front, :back, :side, :row_order_position, :_destroy])
  end

end
