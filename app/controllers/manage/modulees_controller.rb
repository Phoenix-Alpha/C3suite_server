class Manage::ModuleesController < Manage::BaseController
  include FlashcardsHelper
  
  load_and_authorize_resource :product
  def index
    @modulees = Content.where(product_id: @product, actable_type: 'Modulee')
  end

  def show
  end

  def new
  end
  
  def edit
    if params[:id].present?
       @configs = @modulee.configurations
       @quizzes = Content.where(actable_type: 'Modulee', actable_id: params[:id]).last.children.where(actable_type: 'Quiz')
    end
  end

  def create
    if @modulee.save
        
    add_configurations params, "CREATE"
    @modulee.save
    redirect_to manage_product_modulee_url(@product, @modulee), notice: 'Module was successfully created'
  	else
  		render action: :new
  	end
  end

  def comprehensive_quiz
    if params[:id].present?
      @content = Content.where(actable_type: 'Modulee', actable_id: params[:id]).last.children.where(actable_type: 'Quiz')
    end
  end

  def comprehensive_quiz_submit
    add_configurations  params, "COMPREHENSIVE_QUESTIONS"
    @modulee.save
    @configs = @modulee.configurations
    @quizzes = Content.where(actable_type: 'Modulee', actable_id: params[:id]).last.children.where(actable_type: 'Quiz')
    
    redirect_to edit_manage_product_modulee_url(@product, @modulee)
  end

  def update
    if @modulee.update(modulee_params)
      add_configurations params, "UPDATE"
      @modulee.save
      redirect_to	manage_product_modulee_url(@product, @modulee), notice: 'Module was successfully updated.'
  	else
  		render action: :edit
  	end
  end

  def destroy
    @modulee.destroy
    redirect_to manage_product_url(@product), notice: 'Module was successfully destroyed.'
  end

  def add_configurations params, type
    config =""
    comprehensive_questions = ""
    if type == "UPDATE"
      config = params[:modulee]
      comprehensive_questions = @modulee.configurations[:comprehensive_questions]

    elsif type =="COMPREHENSIVE_QUESTIONS"
      config = @modulee.configurations
      comprehensive_questions = params[:comprehensive_questions]
      
    else
      config = params[:modulee]
      comprehensive_questions = params[:modulee][:comprehensive_questions]
    end
    
    @modulee.configurations = {
      auditable_questions_limit: config[:auditable_questions_limit],
      auditable_flashcards_limit:config[:auditable_flashcards_limit],
      auditable_media_limit: config[:auditable_media_limit],
      auditable_htmls_limit: config[:auditable_htmls_limit],
      auditable: (get_bool config[:auditable]),
      skippable: (get_bool config[:skippable]),
      shuffle: (get_bool config[:shuffle]),
      has_bookmarks: (get_bool config[:has_bookmarks]),
      allow_build_quiz: (get_bool config[:allow_build_quiz]),
      incorrect_answered_quiz: (get_bool config[:incorrect_answered_quiz]),
      allow_build_flashcard: (get_bool config[:allow_build_flashcard]),
      allow_comprehensive_quizzes: (get_bool config[:allow_comprehensive_quizzes]),
      allow_comprehensive_flashcards: (get_bool config[:allow_comprehensive_flashcards]),
      time_limit: config[:time_limit],
      startover: (get_bool config[:startover]),
      comprehensive_questions: comprehensive_questions, 
    }
  end

  private
    def modulee_params
    	params.require(:modulee).permit(:title, :section_title, :product_id, :time_limit, :flashcard_sides_count)
    end

    def get_bool value
      value == "1" or value == true
    end
end
