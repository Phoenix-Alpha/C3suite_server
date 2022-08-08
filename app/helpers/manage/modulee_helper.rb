module Manage::ModuleeHelper
  
  def all_modulee_questions_selected? content

  	if content.present? and @modulee.configurations[:comprehensive_questions].present?
  		content.each do |q| 
  			if !all_chapter_questions_selected? (q.specific.questions.pluck("id").map(&:to_s))
  				return false;
  			end
  		end
  		return true		
  	end
  end

  def all_chapter_questions_selected? content
  	if content.present?
	    (content.all? {|x| @modulee.configurations[:comprehensive_questions].include? x}) ? true : false
    end    
  end

  def any_chapter_question_selected? content
  	if content.present?
	    (content.any? {|x| @modulee.configurations[:comprehensive_questions].include? x}) ? true : false
  	end
  end

end
