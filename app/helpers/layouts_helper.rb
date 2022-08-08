module LayoutsHelper
	include ActiveSupport::Inflector
	def getIcon item
		if item.present?
			if item.specific.has_quizzes?
				"fas fa-tasks"
			elsif item.specific.has_flashcards?
				"fas fa-map"
			elsif item.specific.has_htmls?
				"fas fa-code"
			elsif item.specific.has_media?
				"far fa-file-video"
			else
				"fas fa-chevron-right"
			end	
						
		end	
	end

	def parameterize(string, separator: "-", preserve_case: false)
	  # Replace accented chars with their ASCII equivalents.
	  parameterized_string = transliterate(string)

	  # Turn unwanted chars into the separator.
	  parameterized_string.gsub!(/[^a-z\-_]+/i, separator)

	  unless separator.nil? || separator.empty?
	    if separator == "-".freeze
	      re_duplicate_separator        = /-{2,}/
	      re_leading_trailing_separator = /^-|-$/i
	    else
	      re_sep = Regexp.escape(separator)
	      re_duplicate_separator        = /#{re_sep}{2,}/
	      re_leading_trailing_separator = /^#{re_sep}|#{re_sep}$/i
	    end
	    # No more than one of the separator in a row.
	    parameterized_string.gsub!(re_duplicate_separator, separator)
	    # Remove leading/trailing separator.
	    parameterized_string.gsub!(re_leading_trailing_separator, "".freeze)
	  end

	  parameterized_string.downcase! unless preserve_case
	  parameterized_string
	end	
end
