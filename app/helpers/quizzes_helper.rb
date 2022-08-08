module QuizzesHelper
  def show_opt selected, current, correct
    if current[1] == correct
      color = 'green'
    elsif selected == current[0].to_s
      color = 'red'
    end
  end

  def is_exam_mode? mode
    if mode == 'study'
      return false
    elsif mode == 'exam'
      return true
    end  
            
  end   

  def get_percentage questions, total_questions
    if questions.present? and total_questions.present?
      number_with_precision((questions.to_f/total_questions)*100, precision: 1)
    end  
  end  

  def result_status correct, total_questions, percentage
    return if correct.blank? or total_questions.blank? or percentage.blank?

  	if ((correct.to_f/total_questions)*100 >= percentage)
  		flag = true
  	else
  		flag = false
  	end	 
  end  

end  
