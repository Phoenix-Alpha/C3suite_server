class API::V1::ContentsController < ApplicationController
  include ContentsHelper
  before_action :set_content, only: [:chapters, :exams, :show, :build_quiz, :get_build_quiz, :build_flashcard, :get_build_flashcard, :bookmark, :viewed_contents, :modulee_bookmarks, :quiz_attempts, :results, :get_ordered_items, :startover, :comprehensiveQuiz, :comprehensiveFlashcard, :questions ]
  before_action :authorize_request

  def chapters
    raise(ExceptionHandler::UnprocessableEntity, "Content type is not module") if @content.actable_type != "Modulee"
    json_response({success: true, chapters: @content.children})
  end

  def exams
    raise(ExceptionHandler::UnprocessableEntity, "Content type is not module") if @content.actable_type != "Modulee"
    contents = get_exams_for_module_content @content, @current_user
    render json: {success: true, exams: contents}
  end

  def questions
    raise(ExceptionHandler::UnprocessableEntity, "Content type is not module") if @content.actable_type != "Modulee"
    questions = []
    # attempts for all quiz chapters
    @content.children.where(actable_type: "Quiz").each do |content|
      questions.push(content.specific.items)
    end
    questions = questions.flatten
    render json: {success: true, questions: questions}
  end
  
  def show
    content = OpenStruct.new()
    modules = @content.children
    modulee = @content.specific
    @content.attributes.slice("id", "product_id", "actable_type", "actable_id", "title").each do |key, value|
      content[key.to_sym] = value
    end
    
    if @content.actable_type == 'Modulee'
      children = []
      bookmarks = []
      iqs = []
      if modules.present?
        modules.each_with_index do |content, index|
          children.push(content.attributes.merge({"status" => (construct_string content), "children_count" => (children_count content), "configurations" => (get_configurations content), "image" => (content.image("square"))}))
          bookmarks.push(content.bookmarks) if params[:bookmarks].present? and modulee.configurations[:has_bookmarks]
          iqs.push(content.incorrect_questions) if params[:incorrect_questions].present? and modulee.configurations[:incorrect_answered_quiz]
        end
      end
      content[:children] = children
      content[:bookmarks] = modulee.configurations[:has_bookmarks] ? bookmarks.flatten : 'Bookmarks are not enabled for this module.' if params[:bookmarks].present?
      content[:incorrect_questions] = modulee.configurations[:incorrect_answered_quiz] ? iqs.flatten : 'Quiz for incorrect questions is not enabled for this module.' if params[:incorrect_questions].present?
    elsif @content.actable_type == 'Quiz'
      content[:questions] = get_content_types
      content[:viewed] = find_viewed_contents "Question", false
      content[:bookmarks] = @content.bookmarks.where(user: @current_user).pluck(:content_type_id)
    elsif @content.actable_type == 'Flashcard'
      content[:flashcard_items] = ActiveModel::Serializer::ArraySerializer.new(get_content_types, each_serializer: FlashcardItemSerializer)
      content[:viewed] = find_viewed_contents "Flashcard", false
      content[:bookmarks] = @content.bookmarks.where(user: @current_user).pluck(:content_type_id)
    elsif @content.actable_type == 'Html'
      content[:html] = @content.specific
      #content[:isViewed] = (find_viewed_contents "Html", true).present? ? true : false
      content[:bookmarks] = @content.bookmarks.where(user: @current_user).pluck(:content_type_id)
    elsif @content.actable_type == 'Media'
      content[:media] = get_media if @content.present?
    end

    json_response({success: true, contents: content.marshal_dump})
  end

  def build_quiz
    build = build_test params[:chapter_ids], params[:no_of_questions], 'Quiz'
    chapters = Content.find(build.chapter_ids) if build.present?
    questions = items_for_build_test chapters, build.content_type_ids, build.no_of_items, 'Question' if build.present?
    json_response({success: true, questions: questions})
  end

  def get_build_quiz
    contents = OpenStruct.new()
    build = @content.build_tests.where(user: @current_user, content_type: 'Quiz').last
    if build.present?
      chapters = Content.find(build.chapter_ids) if build.chapter_ids.present?
      questions = items_for_build_test chapters, build.content_type_ids, build.no_of_items, 'Question'
   
      build.content_type_ids = questions.pluck("id") if questions.present?
      build.save!
    
      contents[:questions] = questions
      contents[:viewed] = questions.present? ? (find_viewed_contents 'BuildQuiz', false) : [] # send viewed contents to continue progress only when there are questions
      contents[:results] = @content.viewed_contents.where(user_id: @current_user.id, content_type: 'BuildQuiz', completed: true).order(updated_at: :desc)
      
      json_response({success: true, contents: contents.marshal_dump})
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  def build_flashcard
    build = build_test params[:chapter_ids], params[:no_of_flashcards], 'Flashcard'
    chapters = Content.find(build.chapter_ids) if build.present?
    flashcrds = items_for_build_test chapters, build.content_type_ids, build.no_of_items, 'Flashcard' if build.present?
    json_response({success: true, flashcrds: flashcrds})
  end

  def get_build_flashcard
    contents = OpenStruct.new()
    build = @content.build_tests.where(user: @current_user, content_type: 'Flashcard').last
    if build.present?
      chapters = Content.find(build.chapter_ids) if build.chapter_ids.present?
      flashcards = items_for_build_test chapters, build.content_type_ids, build.no_of_items, 'Flashcard'
   
      build.content_type_ids = flashcards.pluck("id") if flashcards.present?
      build.save!
    
      contents[:flashcards] = flashcards
      contents[:viewed] = flashcards.present? ? (find_viewed_contents 'BuildFlashcard', false) : [] # send viewed contents to continue progress only when there are flashcards
      
      json_response({success: true, contents: contents.marshal_dump})
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  def bookmark
    success = false
    content_type_ids = []
    if params[:destroy] == 'true'
      bkm = Bookmark.where(user: @current_user, content_type_id: params[:content_type_id], content_type: params[:content_type])
      success = (bkm.first.destroy ? true : false) if bkm.present?
    elsif params[:content_type_id].present? && params[:content_type].present? && @current_user.present? && @content.present?
      content = params[:content_type].constantize.find(params[:content_type_id]).content
      success = Bookmark.find_or_create_by(user: @current_user, content: content, content_type: params[:content_type], content_type_id: params[:content_type_id]) ? true : false
    end
    
    content_type_ids = @content.bookmarks.where(user: @current_user).pluck(:content_type_id)
    json_response({ success: success, content_type_ids: content_type_ids, actable_type: @content.actable_type })
  end
  

  def modulee_bookmarks
    success = true
    contents = @content.has_parent? ? @content.siblings : @content.children   
    bookmarked_contents = []
    content_types = []
    content_type_ids = []
    
    if contents.present?
      contents.each do |child|
        content_types = child.bookmarks.where(user_id: @current_user.id) if @current_user.present?
        if content_types.present?
          content_type_ids.push(content_types.pluck(:content_type_id))
          # TODO: Avoid extra number of queries for each content_type_id by better handling the following statement
          contents = content_types.map{ |item| item.content_type.constantize.find(item.content_type_id) }
          bookmarked_contents.push({ 
            title: child.title, 
            content_id: child.id, 
            contents:  (isTypeFlashcard? @content) ? ActiveModel::Serializer::ArraySerializer.new(contents, each_serializer: FlashcardItemSerializer) : contents
          })
        end
      end
    end
    content_type_ids = content_type_ids.flatten
    render json: { 
      success: success, 
      bookmarked_contents: bookmarked_contents, 
      content_type_ids: content_type_ids, 
      actable_type: @content.has_parent? ? @content.parent.actable_type : @content.actable_type }
  end


  def viewed_contents
    success = false  
    if @content.actable_type == "Quiz"
      if (((params[:question].present? and params[:index].present?) or params[:time_left].present?) and @content.present?)
        success = save_quiz_viewedcontent params
      end
    elsif @content.actable_type == "Flashcard"
      if params[:flashcarditem].present? and params[:status].present? and @content.present?
        success = save_flashcard_viewedcontent params
      end
    elsif @content.actable_type == "Modulee" and params.present? and params[:type] == "ComprehensiveQuestion"
      if ((params[:question].present? and params[:index].present?) or params[:time_left].present?)
        success = save_quiz_viewedcontent params
      end
    elsif @content.actable_type == "Modulee" and params.present? and params[:type] == "ComprehensiveFlashcard"
      if params[:flashcarditem].present? and params[:status].present? and @content.present?
        success = save_flashcard_viewedcontent params
      end
    elsif @content.actable_type == "Html"
      success = save_html_viewedcontent
    end

    render json: {success: success}
  end

  def quiz_attempts
    success = false
    attempts = OpenStruct.new()
    contents = []
    if @content and @content.actable_type == "Modulee"
      # attempts for comprehensive quiz
      @content.viewed_contents.where(user_id: @current_user.id)
      viewed = @content.viewed_contents.where(user_id: @current_user.id, completed: true).order(updated_at: :desc)
      attempts[:comprehensive] = {id: @content.id, title: @content.title, attempts: viewed.size, last_attempt: viewed.first.updated_at} if viewed.present?
      
      # attempts for all quiz chapters
      @content.children.where(actable_type: "Quiz").each do |content|
        viewed = content.viewed_contents.where(user_id: @current_user.id, completed: true).order(updated_at: :desc)
        contents.push({id: content.id, title: content.title, attempts: viewed.size, last_attempt: viewed.first.updated_at}) if viewed.present?
    
      end
      attempts[:contents] = contents
      success = true
    end

    render json: {success: success, attempts: attempts.marshal_dump}
  end

  def comprehensiveQuiz
    return if !@current_user
    content = OpenStruct.new()
    
    if @content and @content.actable_type == "Modulee"
      content[:questions] = get_content_types "ComprehensiveQuestion"
      content[:bookmarks] = Bookmark.where(user_id: @current_user.id, content_type: "Question").pluck(:content_type_id) & content[:questions].pluck("id").map(&:to_i)
      content[:viewed] = find_viewed_contents "ComprehensiveQuestion", false  
    
      render json: content.marshal_dump
    else
      render json: {success: false}
    end
  end


  def comprehensiveFlashcard
    return if !@current_user
    content = OpenStruct.new()
    
    if @content and @content.actable_type == "Modulee"
      items = get_content_types "ComprehensiveFlashcard"
      if items.present?
        content[:flashcard_items] = ActiveModel::Serializer::ArraySerializer.new(items, each_serializer: FlashcardItemSerializer)
        content[:bookmarks] = Bookmark.where(user_id: @current_user.id, content_type: "FlashcardItem").pluck(:content_type_id) & items.pluck("id").map(&:to_i)
        content[:viewed] = find_viewed_contents "ComprehensiveFlashcard", false  
      end  
      render json: content.marshal_dump
    else
      render json: {success: false}
    end
  end


  def results
    results = []
    if @content and @content.actable_type == "Quiz"
      viewed_contents = @content.viewed_contents.where(user_id: @current_user.id, ancestry: @content.ancestry, completed: true).order(updated_at: :desc)
      if viewed_contents.present?
        viewed_contents.each do |item|
          result = get_result_stats item
          results.push(result) if result.present?   
        end
      end
    elsif @content and @content.actable_type == "Modulee"
      viewed_contents = @content.viewed_contents.where(user_id: @current_user.id, completed: true).order(updated_at: :desc)
      if viewed_contents.present?
        viewed_contents.each do |item|
          result = get_result_stats item
          results.push(result) if result.present?   
        end
      end
    end
    json_response({success: true, results: results})
  end


  def result
    success = false
    viewed_content = ViewedContent.find(params[:id])
    data = viewed_content.content_type_id
    bookmarks = viewed_content.content.user_bookmarks(@current_user).pluck(:content_type_id)
    questions = Question.where(id: data.keys)
    viewed = ActiveModel::Serializer::CollectionSerializer.new(questions, each_serializer: QuestionSerializer, viewed_data: data, bookmarks: bookmarks )
    success = true if viewed.present?
    json_response({success: success, result: viewed})
  end


  def startover
    success = false
    if @content.actable_type == "Quiz"
      data = find_viewed_contents "Question", false
      success = (data.delete ? true : false) if data.present?
    elsif @content.actable_type == "Flashcard"
      data = find_viewed_contents "Flashcard", false
      success = (data.delete ? true : false) if data.present?
    end

    json_response({ success: success })
  end




  private

  def get_media
    mediaStruct = OpenStruct.new() 
    media = @content.specific 
    media.attributes.each do |key, value|
      key == "source_data" ? mediaStruct[key] = media.source_url : mediaStruct[key] = value
    end

    mediaStruct.marshal_dump
  end

  def save_quiz_viewedcontent params
    success = false
    data = ViewedContent.find_or_create_by(user: @current_user, content_id: @content.id, ancestry: (@content.ancestry.present? ? @content.ancestry : nil), content_type: params[:type] , completed: false)
    if params[:question].present? and params[:index].present? and @content.present?
      data.content_type_id[params[:question]] = { selected: params[:index], order: params[:order] }
    end
    if params[:time_left].present?
      data.remaining_time = params[:time_left]
    end  
    data.completed = params[:completed]
    data.save
    success = true
  end

  def save_flashcard_viewedcontent params
    success = false

    data = ViewedContent.find_or_create_by(user: @current_user, content: @content, content_type: params[:type], ancestry: @content.ancestry)
    if params[:flashcarditem].present? and params[:status].present?
      data.content_type_id = {} if data.completed
      data.content_type_id[params[:flashcarditem]] = nil
      data.completed = params[:status]
      data.save
    end
    success = true
  end

  def save_html_viewedcontent
    data = ViewedContent.find_or_create_by(user: @current_user, content: @content, content_type: "Html", ancestry: @content.ancestry)
    data.completed = true
    data.save ? true : false
  end
  
  # returns content types (i.e questions and flashcards) after arranging w.r.t saved progress.
  def get_content_types content_type = nil  
    if @content.actable_type == "Quiz"
      all = @content.specific.questions.ids.map(&:to_s)
      viewed = (find_viewed_contents "Question", false)
      if viewed.present?
        viewed = viewed.content_type_id.keys 
        ordered = viewed + (all - viewed)
        content_types = Question.where(id: ordered)
      else
        content_types = Question.where(id: all)
      end
    
    elsif @content.actable_type == "Flashcard"
      all = @content.specific.flashcard_items.ids.map(&:to_s)
      viewed = (find_viewed_contents "Flashcard", false)
      if viewed.present?
        viewed = viewed.content_type_id.keys 
        ordered = viewed + (all - viewed)
        content_types = FlashcardItem.where(id: ordered)
      else
        content_types = FlashcardItem.where(id: all)
      end

    # In case of comprehensive quiz
    elsif(@content.actable_type == "Modulee" and content_type == "ComprehensiveQuestion")
      modulee = @content.specific if @content.present?
                                                              # returns questions ids              returns questions
      modulee.configurations[:comprehensive_questions]
      questions = (modulee.configurations.present? and modulee.configurations[:comprehensive_questions].present?) ? modulee.configurations[:comprehensive_questions] : pluck_all_module_specific_questions
      all = (modulee.configurations.present? and modulee.configurations[:comprehensive_questions].present?) ? questions.map(&:to_s) : questions.pluck("id").map(&:to_s)
      viewed = (find_viewed_contents content_type, false)

      if viewed.present?
        viewed = viewed.content_type_id.keys
        ordered = viewed + (all - viewed) 
        questions =  Question.where(id: ordered)
      else
        if (modulee.configurations.present? and modulee.configurations[:comprehensive_questions].present?)
          questions =  Question.where(id: questions)
        else 
          questions
        end
      end
    
    elsif(@content.actable_type == "Modulee" and content_type == "ComprehensiveFlashcard")
      modulee = @content.specific if @content.present?
      flashcard_items = pluck_all_module_specific_flashcards || []
      all = flashcard_items.pluck("id").map(&:to_s) 
      viewed = (find_viewed_contents content_type, false)
      
      if viewed.present?
        viewed = viewed.content_type_id.keys
        ordered = viewed + (all - viewed)
        flashcard_items = FlashcardItem.where(id: ordered)
      else
        flashcard_items = FlashcardItem.where(id: all)
      end
    end   
  end


  def getFlashcardItems items
    flashcard_items = FlashcardItem.where(id: items)
  end
  
  def pluck_all_module_specific_questions
    quizzes = @content.children.where(actable_type: 'Quiz')
    questions = []

    quizzes.each do |quiz|
      questions.push(quiz.specific.questions) if quiz.specific.questions.present?
    end

    questions = questions.flatten
  end

  def pluck_all_module_specific_flashcards
    flashcards = @content.children.where(actable_type: 'Flashcard')
    flashcardItems = []

    flashcards.each do |flashcard|
      flashcardItems.push(flashcard.specific.flashcard_items) if flashcard.specific.flashcard_items.present?
    end

    flashcardItems = flashcardItems.flatten
  end

  def find_viewed_contents content_type, completed
    ViewedContent.where(user: @current_user, content: @content, content_type: content_type, ancestry: (@content.ancestry.present? ? @content.ancestry : nil), completed: completed).last
  end

  def set_content
    @content = Content.find(params[:id]) if params[:id].present?
  end

  def get_result_stats item
    return if item.nil?
    content_type_ids = item.content_type_id.values 

    correct_count = content_type_ids.count {|c| c[:selected] == '0'}
    incorrect_count = content_type_ids.count - content_type_ids.count {|c| c[:selected] == '0' or c[:selected] == '-1' }
    skipped = content_type_ids.count - (correct_count + incorrect_count)
    
    return {id: item.id, viewed_at: item.updated_at, correct_answers: correct_count, incorrect_answers: incorrect_count, unattempted_answers: skipped}   
  end

  def build_test chapter_ids, no_of_items, content_type
    content = Content.find(chapter_ids).pluck(:actable_type).uniq.include? content_type if chapter_ids.present?
    raise(ExceptionHandler::BadRequest, Message.missing_parameters) if chapter_ids.blank? or no_of_items.blank?
    raise(ActiveRecord::RecordNotFound, "Contents of type #{content_type} not found for given chapter ids #{chapter_ids}") unless content
    raise(ExceptionHandler::BadRequest, Message.invalid_type('content', content_type)) unless @content.specific.has_children_type? content_type
    
    build = BuildTest.find_or_create_by(content: @content, user: @current_user, content_type: content_type)
    build.chapter_ids = chapter_ids
    build.no_of_items = no_of_items
    
    # overwrite the existing progress in case of new build test request
    viewed = @content.viewed_contents.where(user_id: @current_user.id, content_type: "Build#{content_type}", completed: false)
    viewed.delete_all if viewed.present?
    build.content_type_ids = nil
    build if build.save!
  end
end
