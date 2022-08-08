class QuestionSerializer < ActiveModel::Serializer
	attributes :id, :question, :explanation, :options, :selected, :correct, :status, :is_bookmarked

	def id
		self.object.id
	end

	def question
		self.object.question
	end

	def explanation
		self.object.explanation
	end

	def options
		data = @instance_options[:viewed_data] if @instance_options[:viewed_data].present?
		question = self.object
		k = 1
		opts = {}
		opts[0] = question.correct
		selected = data["#{question.id}"][:selected]

		while (k < 10 && distractor = question.send("distractor#{k}"))
			opts[k] = distractor if distractor.present?
			k += 1
		end
		order = data["#{question.id}"][:order].split('')
		opts = opts.sort_by{ |obj| order.index obj.first.to_s }
	end

	def selected
		data = @instance_options[:viewed_data] if @instance_options[:viewed_data].present?
		question = self.object
		
		selected = data["#{question.id}"][:selected]
	end

	def correct
		self.object[:correct]
	end

	def status
		data = @instance_options[:viewed_data] if @instance_options[:viewed_data].present?
		question = self.object
		selected = data["#{question.id}"][:selected]
		selected == "0" ? "Correct" : selected == "-1" ? "Unattempted" : "Incorrect"
	end

	def is_bookmarked
		bookmarks = @instance_options[:bookmarks] || []
		bookmarks.include? self.object.id
	end
end
  