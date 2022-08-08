module ContentsHelper
	def show_progress content
		viewed = viewedcontents content
		return 0 if viewed.blank?
		viewed_count = viewed.nil? ? 0 : viewed.content_type_id.keys.count
		total = children_count content
		total > 0 ? (viewed_count.to_f / total.to_f).to_i : 0 
	end

	def last_active content
		contents = current_user.viewed_contents.where(content_id: content.id) if current_user.present?
		if contents.present?
			contents.last.updated_at.strftime('%m/%d/%Y at%l:%M %P')
		else
			'Never'
		end
	end

	def children_count content
		if content.actable_type == "Quiz"
			total = Quiz.find(content.actable_id).questions.count
		elsif content.actable_type == "Flashcard"
			total = Flashcard.find(content.actable_id).flashcard_items.count
		end
	end	
	
	def viewedcontents content
		current_user.viewed_contents.where(content_id: content.id, ancestry: content.ancestry).last if current_user.present?
	end

	def construct_string content
		viewed = viewedcontents content
		return if viewed.blank?
		viewed_count = viewed.nil? ? 0 : viewed.content_type_id.keys.count 
		if content.actable_type == 'Quiz'
			total = Quiz.find(content.actable_id).questions.count
		elsif content.actable_type == 'Flashcard'
			total = Flashcard.find(content.actable_id).flashcard_items.count
		end

		if viewed.nil?
			str = "Not Started"
		elsif viewed_count == total or viewed.completed 
			str = "Completed"
		else
			str = "#{viewed_count} / #{total}"
		end
	end

	def progress_check content
		return if current_user.blank?
		contents = current_user.viewed_contents.where(content_id: content.id, content_type: "Question", ancestry: content.actable_id, completed: false).count
		contents == 0 ? "Take a " : "Continue"
	end

	def viewed_html content
		if current_user.present?
			contents = current_user.viewed_contents.where(content_id: content.id, content_type: 'Html')
			if contents.present?
				str = "Completed"
			else
				str = "Not Started"
			end	
		end	
	end

	def viewed_media content
		contents = current_user.viewed_contents.where(content_id: content.id, content_type: 'Media') if current_user.present?
		if contents.present?
			str = "Completed"
		else
			str = "Not Started"
		end		
	end

	def modulee_type content
        if content.present?
            children_actable_types = content.children.pluck(:actable_type).uniq.reject(&:empty?)
            children_actable_types.size > 1 ? 'Mix' : children_actable_types.first
        end
	end
	
	def isTypeFlashcard? content
		(modulee_type content) == "Flashcard" ? true : false
	end

	def isTypeQuiz? content
		(modulee_type content) == "Quiz" ? true : false
	end

	def isTypeHtml? content
		(modulee_type content) == "Html" ? true : false
	end

	def isTypeMedia? content
		(modulee_type content) == "Media" ? true : false
	end

	def isTypeMix? content
		(modulee_type content) == "Mix" ? true : false
	end

	def get_module_configurations content	# Change in response of this method could effect all the configurations of features. On change in response test all the features where this method is called.
		return if content.blank?
		modulee = content.specific.attributes.symbolize_keys
	end

	def get_configurations content
		return if content.blank?
		modulee_configs = (get_module_configurations content.parent)[:configurations]
		modulee_configs = modulee_configs.merge(content.specific.attributes.symbolize_keys) if ((content.actable_type == "Quiz"  or content.actable_type == "Flashcard") and !content.specific.inherit_modulee_configs)
		modulee_configs
		# TODO: enable configurations for media when bookmark feature for media gets completed.  
	end

	def get_auditable_questions content, limit = 20
		return if content.blank?
		questions = [] 
		content.specific.children.where(actable_type: 'Quiz').each do |content_item|
			break if limit <= 0
			items = content_item.specific.questions.first(limit)
			questions.push(items)
			limit -= items.count
		end
		questions.flatten
	end

	def get_auditable_flashcards content, limit = 20
		return if content.blank?
		flashcard_items = [] 
		content.specific.children.where(actable_type: 'Flashcard').order("RAND()").each do |content_item|
			break if limit <= 0
			items = content_item.specific.flashcard_items.first(limit)
			flashcard_items.push(items)
			limit -= items.count
		end
		flashcard_items.flatten
	end

	def get_auditable_media content
		return if content.blank?
		media_items = [] 
		content.specific.children.where(actable_type: 'Media').each do |content_item|
			mediaStruct = OpenStruct.new() 
			media = content_item.specific 
			media.attributes.each do |key, value|
				key == "source_data" ? mediaStruct[key] = media.source_url : mediaStruct[key] = value
			end
			media_items.push(mediaStruct.marshal_dump)
		end
		media_items.flatten
	end

	def get_auditable_html content
		return if content.blank?
		html_items = [] 
		content.specific.children.where(actable_type: 'Html').order("RAND()").each do |content_item|
			html_items.push(content_item)
		end
		html_items.flatten
	end

	def no_of_questions # Number of questions for build a quiz
		[["25", "25"], ["50", "50"], ["100", "100"], ["200", "200"], ["All", "All"]]
	end

	def items_for_build_test contents, content_type_ids, no_of_items, type
		return [] unless contents.present? and no_of_items.present?
		items = []
		if content_type_ids.present?
			items = type.constantize.find(content_type_ids)
		else
			all_items = []
			limit = no_of_items.to_i / contents.length unless no_of_items == 'All' and no_of_items.empty?
			contents.each do |content|
				if no_of_items == "All"
				items.push(content.specific.items.shuffle)
				else
				shuffled = content.specific.items.shuffle
				taken = shuffled.take(limit)
				all_items.push(shuffled - taken)
				items.push(taken)
				end
			end
			all_items.flatten!
			items.flatten!
			remaining_limit = no_of_items.to_i - items.length unless no_of_items == "All" and questions.empty?
			if remaining_limit.present? and remaining_limit > 0
				random_taken = all_items.shuffle.take(remaining_limit)
				items.push(random_taken)
				items.flatten!
			end
		end
		items
	end

	def get_exams_for_module_content cntnt, user	# Used by api
		return nil if cntnt.blank? or user.blank?
		contents = []
		# attempts for all quiz chapters
		cntnt.children.where(actable_type: "Quiz").each do |content|
			viewed_contents = []
			viewed = content.viewed_contents.where(user_id: user.id, completed: true, content_type: 'Question').order(updated_at: :desc)
			viewed.each do |item|
				data = item.content_type_id
				questions = Question.where(id: data.keys)
				bookmarks = item.content.user_bookmarks(user).pluck(:content_type_id)
				questions = ActiveModel::Serializer::CollectionSerializer.new(questions, each_serializer: QuestionSerializer, viewed_data: data, bookmarks: bookmarks)
				obj = {}
				obj[:questions] = questions  # the questions in an attempt
				obj[:no_of_incorrect_questions] = questions.count { |q| q.status == "Incorrect" }
				obj[:no_of_correct_questions] = questions.count { |q| q.status == "Correct" }
				obj[:no_of_skipped_questions] = questions.count { |q| q.status == "Unattempted" }
				
				viewed_contents.push(obj)
			end
			contents.push({id: content.id, title: content.title, no_of_attempts: viewed.size, last_attempt: viewed.first.updated_at, attempts: viewed_contents}) if viewed.present?
		end
		contents
	end
end
