class Manage::QuizzesController < Manage::BaseController
  include FileUpload

  before_action :set_content, except: [:destroy]
  load_and_authorize_resource :product

  def new
  end
  
  def edit
  end

  def show
  end

  def create
    if @quiz.save
      redirect_to manage_product_url(@product), notice: 'Quiz was successfully created'
    else
      # persist content if the form validation fails
      @content ||= Content.find(quiz_params[:parent_id].to_i) if quiz_params[:parent_id].present?
      render action: :new
    end
  end

  def update
    if @quiz.update(quiz_params)
     redirect_to manage_product_url(@product), notice: 'Quiz was successfully updated.'
    else
      render action: :edit
    end
  end

  def destroy
    @quiz.destroy
    redirect_to manage_product_url(@product), notice: 'Quiz was successfully destroyed.'
  end

  def download
    @quiz = Quiz.find(params[:quiz_id])
    respond_to do |format|
      format.csv { send_data @quiz.questions.to_csv, filename: "quiz-#{@quiz.title}-#{Date.today}.csv" }
    end
  end

  private
  def set_content
    @content ||= Content.find(params[:content_id]) if params[:content_id].present?
  end

  def quiz_params
    params.require(:quiz).permit(:title, :q_type, :description, :time_limit, :back_navigation, :shuffle, :passing_percentage, :start_over, :skippable, :inherit_modulee_configs, :parent_id, :product_id, questions_attributes: [:id, :question, :hint, :explanation, :correct, :distractor1, :distractor2, :distractor3, :distractor4, :distractor5, :distractor6, :distractor7, :distractor8, :distractor9, :category, :_destroy])
  end

end
