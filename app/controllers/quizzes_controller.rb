class QuizzesController < ApplicationController
  include ContentsHelper
  before_action :set_quiz, only: [:instructions, :viewedcontent, :startover, :results, :study, :exam, :result]
  before_action :set_breadcrumbs
  before_action :set_mode, only: [:comprehensive, :exam, :study, :startover_for_comprehensive, :startover]
  before_action :set_content, only: [:comprehensive, :comp_viewedcontent, :build, :build_quiz, :build_viewedcontent, :instructions_for_comprehensive, :startover_for_comprehensive, :results_for_comprehensive, :result_for_comprehensive, :results_for_build, :result_for_build, :instructions_for_incorrect, :quiz_for_incorrect, :incorrect_viewedcontent, :results_for_incorrect, :result_for_incorrect, :incorrect_listing]

  layout 'product'
  def show
    @questions = @quiz.questions if @quiz.present?
    @questions = @questions.shuffle if @questions.present? && @quiz.shuffle


    if @quiz.present?
      @title = @quiz.title
      @modulee = @quiz.root.specific
      config = (get_configurations(@quiz.content))
      @skippable = config[:skippable]
      @startover = config[:start_over] ? config[:start_over] : config[:startover]
      @has_bookmarks = config[:has_bookmarks]
      @bookmarks = @quiz.content.user_bookmarks(current_user).pluck(:content_type_id)
      @back_navigation = config[:back_navigation]
    end
  end

  def comprehensive
    @questions = []
    question_ids = []
    modulee = get_module_configurations @content
    configurations = modulee[:configurations] if modulee.present?
    @bookmarks = Bookmark.where(user: current_user, content_type: 'Question').pluck(:content_type_id)
    @has_bookmarks = configurations[:has_bookmarks]
    @time_limit = configurations[:time_limit] if configurations[:time_limit].present?
    @back_navigation = configurations[:back_navigation]
    if configurations[:comprehensive_questions].present?
      question_ids = configurations[:comprehensive_questions]
    else
      question_ids = (get_auditable_questions @content).pluck("id").map(&:to_s)
    end

    @title = 'Comprehensive Quiz'
    @viewed = (find_contents @content, "ComprehensiveQuestion", false).last
    if @viewed.blank? or @mode == 'study'
      @index = 0
      @questions =  Question.find(question_ids) if question_ids.present?
    else
      @time_left = @viewed.remaining_time
      all = question_ids if question_ids.present?
      comp_viewed = @viewed.content_type_id.keys
      ordered = comp_viewed + (all - comp_viewed) 
      @index = comp_viewed.count 
      @questions =  Question.find(ordered)   
    end
    @result_path = comprehensive_results_quizzes_path(content_id: @content)
    render @mode

  end

  def build_quiz
    build = @content.build_tests.where(user: current_user, content_type: 'Quiz').last
    if build.present?
      contents = Content.find(build.chapter_ids) if build.chapter_ids.present?
      questions = items_for_build_test contents, build.content_type_ids, build.no_of_items, 'Question'

      build.content_type_ids = questions.pluck("id") if questions.present? and no_of_questions.blank?
      build.save!
      @title = 'Build a Quiz'
      @content = Content.find(params[:content_id])
      modulee = get_module_configurations @content
      configurations = modulee[:configurations] if modulee.present?
      @has_bookmarks = configurations[:has_bookmarks]
      @bookmarks = Bookmark.where(user: current_user, content_type: 'Question').pluck(:content_type_id)
      @index = 0
      @questions = questions
      @mode = params[:mode] ? params[:mode] : "exam"
      
      viewed = (find_contents @content, 'BuildQuiz', nil, false).last
      if viewed.present?
        all = @questions.pluck("id").map(&:to_s) if @questions.present?
        comp_viewed = viewed.content_type_id.keys
        ordered = comp_viewed + (all - comp_viewed) 
        @index = comp_viewed.count 
        @questions =  Question.find(ordered)
      end
      @result_path =  build_results_quizzes_path(content_id: params[:content_id])
      render @mode
    end
  end

  def study
    add_breadcrumb 'Start', study_quiz_path(@quiz)
    @index = 0
    show
  end

  def exam
    add_breadcrumb 'Start', exam_quiz_path(@quiz)
    show
    @time_limit = @quiz.time_limit if @quiz.time_limit.present?
    @viewed = (find_contents @quiz.content, "Question", @content.present? ? @content.ancestry : @quiz.present? ? @quiz.ancestry : '', false).last if current_user.present?
 
    if @viewed.blank?
      @index = 0
    else
      @time_left = @viewed.remaining_time
      viewed = @viewed.content_type_id.keys

      all = @questions.pluck("id").map(&:to_s)
      ordered = viewed + (all - viewed)
      @index = viewed.count
      @questions = Question.find(ordered)
    end
    @result_path = results_quiz_path
  end

  def incorrect_listing
    contents = IncorrectQuestion.where(user: current_user).pluck(:content_id).uniq
    @iqs = []
    contents = Content.find(contents)

    contents.each do |content|
      questions = content.incorrect_questions.pluck(:content_type_id)
      @iqs.push({ :content => content, :questions => Question.find(questions) }) if questions.present?
    end
    
  end

  def quiz_for_incorrect
    @mode = 'study'
    questions = IncorrectQuestion.where(user: current_user).pluck(:content_type_id)
    index = questions.index(params[:qid].to_i) if params[:qid].present?
    questions = questions[index..questions.length] + questions[0..index-1] if index.present?
    @index = 0
    @questions = Question.find(questions)
    @result_path =  incorrect_results_quizzes_path(content_id: @content.id)
    render @mode
  end

  def build
    if params.present?
      return redirect_to request.referrer, flash: {error: "Chapters not selected"} if params[:chapters].blank?
      build = BuildTest.find_or_create_by(user: current_user, content: @content, content_type: 'Quiz')
      build.chapter_ids = params[:chapters]
      build.no_of_items = params[:select]
      
      viewed = find_contents @content, 'BuildQuiz', nil, false
      viewed.delete_all if viewed.present?
      
      build.content_type_ids = nil
      build.save!
      
      @study_path = build_quizzes_path(content_id: params[:id], mode: 'study')
      @quiz_path = build_quizzes_path(content_id: params[:id], mode: 'exam')
      @result_path =  build_results_quizzes_path(content_id: params[:id])
      render :instructions
    end
  end


  def instructions
    # show_build_a_quiz_content_path(item)
    add_breadcrumb 'Instructions', instructions_quiz_path(@quiz)
    @attempts = (find_contents @quiz.content, "Question", @quiz.content.ancestry, false).count if current_user.present?
    @study_path = study_quiz_path(@quiz.id, mode: 'study') if @quiz.present?
    @quiz_path = exam_quiz_path(@quiz.id, mode: 'exam')
    @exam_path = exam_startover_quiz_path(@quiz.id,  mode: 'exam')
    @result_path =  results_quiz_path
  end
  
  def instructions_for_comprehensive
    add_breadcrumb 'Instructions', comprehensive_instructions_quizzes_path
    @attempts = (find_contents @content, "ComprehensiveQuestion" , false).count
    @study_path = comprehensive_quizzes_path(content_id: @content.id, mode: 'study')
    @quiz_path = comprehensive_quizzes_path(content_id: @content.id, mode: 'exam')
    @exam_path = comprehensive_startover_quizzes_path(content_id: @content.id, mode: 'exam')
    @result_path = comprehensive_results_quizzes_path(content_id: @content.id)
    render :instructions
  end

  def bookmark
    success = false

    return if !current_user

    if params[:destroy] == 'true'
      bkm = Bookmark.where(user: current_user, content_type_id: params[:question])
      bkm.first.destroy if bkm.present?

      success = true
    
    elsif params[:question].present?
      question  = Question.find(params[:question])
      success = true if question.present? and Bookmark.find_or_create_by(user: current_user, content: question.quiz.content, content_type: "Question", content_type_id: params[:question])
    end
    
    render json: { success: success }
  end

  def comp_viewedcontent
    success = false
    return if !current_user

    data = ViewedContent.find_or_create_by(user: current_user,  content_id: @content.id, content_type: "ComprehensiveQuestion", completed: false)
    if params[:question].present? and params[:index].present?
      data.content_type_id[params[:question]] = { selected: params[:index], order: params[:order] }
      unless params[:index] == "0"
        question  = Question.find(params[:question])
        iq = IncorrectQuestion.find_or_create_by(user: current_user, content: question.quiz.content, content_type_id: params[:question])
      end
    end
    if params[:time_left].present?
      data.remaining_time = params[:time_left]
    end  
    data.completed = params[:completed]
    data.save
    success = true
    render json: { success: success }
  end

  def viewedcontent
    success = false
    return if !current_user.present?
    data = current_user.viewed_contents.find_or_create_by(content: @quiz.content, content_type: "Question", ancestry: @quiz.content.ancestry, completed: false)
    if params[:question].present? and params[:index].present?
      data.content_type_id[params[:question]] = { selected: params[:index], order: params[:order] }
      unless params[:index] == "0"
        iq = IncorrectQuestion.find_or_create_by(user: current_user, content: @quiz.content, content_type_id: params[:question])
      end
    end
    if params[:time_left].present?
      data.remaining_time = params[:time_left]
    end  
    data.completed = params[:completed]
    data.save
    success = true
    render json: { success: success }
  end

  def build_viewedcontent
    success = false
    return if !current_user

    data = ViewedContent.find_or_create_by(user: current_user,  content_id: @content.id, content_type: "BuildQuiz", completed: false)
    if params[:question].present? and params[:index].present?
      data.content_type_id[params[:question]] = { selected: params[:index], order: params[:order] }
      unless params[:index] == "0"
        question  = Question.find(params[:question])
        iq = IncorrectQuestion.find_or_create_by(user: current_user, content: question.quiz.content, content_type_id: params[:question])
      end
    end
    if params[:time_left].present?
      data.remaining_time = params[:time_left]
    end  
    data.completed = params[:completed]
    data.save
    success = true
    render json: { success: success }
  end

  def incorrect_viewedcontent
    success = false
    return if !current_user
    if params[:question].present? and params[:index].present? and params[:index] == "0"
      question = IncorrectQuestion.where(user: current_user, content_type_id: params[:question])
      success = true if question.present? and question.delete_all
    end
    render json: { success: success }
  end

  def startover
    if @quiz
      data = find_contents @quiz.content, "Question", @quiz.content.ancestry, false
      data.delete_all if data.present?
      redirect_to exam_quiz_path(@quiz, mode: @mode) 
    end
  end

  def startover_for_comprehensive
    if @content
      data = find_contents @content, "ComprehensiveQuestion", false
      data.delete_all if data.present?      redirect_to exam_quiz_path(@quiz.id, mode: @mode)

      redirect_to comprehensive_quizzes_path(content_id: @content, mode: @mode)
    end  

  end  

  def result
    @bookmarks = @quiz.content.user_bookmarks(current_user).pluck(:content_type_id)
    @data = (find_contents @quiz.content, "Question", @quiz.content.ancestry, true).find(params[:attempt_id]).content_type_id
    @questions = Question.find(@data.keys)
  end

  def result_for_comprehensive
    @is_subscribed = UserSubscription.subscription_current?(current_user, @content.product_id)
    if @is_subscribed
      @bookmarks = Bookmark.where(user: current_user, content_type: 'Question').pluck(:content_type_id)
    end
    @data = (find_contents @content, "ComprehensiveQuestion", true).find(params[:attempt_id]).content_type_id  
    @questions = Question.find(@data.keys)
    render :result
  end  

  def result_for_build
    @is_subscribed = UserSubscription.subscription_current?(current_user, @content.product_id)
    if @is_subscribed
      @bookmarks = Bookmark.where(user: current_user, content_type: 'Question').pluck(:content_type_id)
    end
    @data = (find_contents @content, "BuildQuiz", true).find(params[:attempt_id]).content_type_id  
    @questions = Question.find(@data.keys)
    render :result
  end

  def result_for_incorrect
    @is_subscribed = UserSubscription.subscription_current?(current_user, @content.product_id)
    if @is_subscribed
      @bookmarks = Bookmark.where(user: current_user, content_type: 'Question').pluck(:content_type_id)
    end
    @data = (find_contents @content, "IncorrectQuestion", true).find(params[:attempt_id]).content_type_id  
    @questions = Question.find(@data.keys)
    render :result
  end

  def results
    @attempts = (find_contents @quiz.content, "Question", @quiz.content.ancestry, true).order(updated_at: :desc)
  end

  def results_for_comprehensive
    @type = "Comprehensive"
    @attempts = (find_contents @content, "ComprehensiveQuestion", true).order(updated_at: :desc)
    render :results
  end

  def results_for_build
    @type = "Build"
    @attempts = (find_contents @content, "BuildQuiz", true).order(updated_at: :desc)
    render :results
  end

  def results_for_incorrect
    @attempts = (find_contents @content, "IncorrectQuestion", true).order(updated_at: :desc)
    render :results
  end

  def audit
    if params[:id].present?
      @modulee =  Content.find(params[:id]).specific
      @questions = []
      @mode = 'study'
      product = Product.find(@modulee.product.id)
      modulee = (get_module_configurations @modulee.content) if @modulee.present?
      configurations = modulee[:configurations] if modulee.present?
      quizzes_count = configurations[:auditable_questions_limit].to_i if configurations.present?
      quizzes = @modulee.children.where(actable_type: 'Quiz')
      quizzes.each do |quiz|
        count = quiz.specific.questions.count
        if quizzes_count <= count 
          @questions.push(quiz.specific.questions.limit(quizzes_count)) if quiz.specific.questions.present?
           break
        else
          @questions.push(quiz.specific.questions.limit(count)) if quiz.specific.questions.present?
          quizzes_count = quizzes_count - count
        end
        
      end
      @questions = @questions.flatten
      @index = 0
    end
  end

  private
    def set_quiz
      @quiz = Quiz.find(params[:id]) if params[:id].present?
    end

    def set_content
      @content = Content.find(params[:content_id]) if params[:content_id].present?
    end

    def set_mode
      @mode = params[:mode] if params[:mode].present? 
    end

    def find_contents content, content_type, ancestry = nil, completed
      current_user.viewed_contents.where(content: content, content_type: content_type, ancestry: ancestry, completed: completed) if current_user.present?
    end

    def set_breadcrumbs
      add_breadcrumb "Home", dashboard_path
      if @quiz.present?
        add_breadcrumb @quiz.parent.product.title, product_path(@quiz.parent.product)
        add_breadcrumb @quiz.parent.title, content_path(@quiz.parent)
      else
        content_id = params[:content_id]

        if content_id.present?
          product = Content.find(content_id).product
          add_breadcrumb product.title, product_path(product)
        end
      end
    end
end
