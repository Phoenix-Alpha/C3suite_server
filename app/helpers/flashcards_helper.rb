module FlashcardsHelper
	
	# sides for form
	def front_manage f
		content_tag :div, (content_tag :h5, @flashcard.sides_label[:front]) + (f.text_area :front, { class: 'form-control', placeholder: @flashcard.sides_label[:front] }),  class: ['form-group','field']		
	end

	def back_manage f
		content_tag :div, (content_tag :h5, @flashcard.sides_label[:back]) + (f.text_area :back, { class: 'form-control', placeholder: @flashcard.sides_label[:back] }),  class: ['form-group','field']
	end

	def side_manage	f
		content_tag :div, (content_tag :h5, @flashcard.sides_label[:side]) + (content_tag :span, f.object.side.present? ? f.object.side.original_filename : "(No File Attached)", class: "attached-label mr-4 #{f.object.side.present? ? 'text-primary' : 'text-warning' }"  ) + (f.file_field :side, class: 'attachment-field'), class: 'form-group field'
	end
	#


	# sides for user view
	def front_view item, i	
		content_tag :h3, raw(item.front.upcase), class: ['mt-5 mb-5  front-item', i == 0  ? '' : (item.side.present? ?  'd-none' : '')]
	end

	def back_view item, i
		content_tag :h4, raw(item.back.upcase), class: ['mt-5 mb-5  back-item', i == 0 ? '' : 'd-none']
	end
	
	def side_view item, i
		if item.side.present?	
			if %w{jpg png jpeg}.include?(item.side.extension)
				content_tag :div, (image_tag item.side_url, class: ['img-thumbnail', 'side-item', i == 0 ? '' : 'd-none']) + (link_to image_tag("download.png" , class: ['download-icon']), item.side_url ,title:'Download Image', :target => "_blank") , class: ['text-center side-item', i == 0 ? '' : 'd-none']
			elsif %w{pdf}.include?(item.side.extension)
				content_tag :div, (link_to image_tag("download.png" , class: ['download-icon'] ) + (content_tag :h5, item.side.original_filename), item.side_url, title:'Download PDF', :target => "_blank") , class: ['text-center mt-5 side-item', i == 0 ? '' : 'd-none']
			end	

	    end    
	end
	#


	# returns label for given flashcard_side name or default (used to generate labeled buttons for flashcards)
	def get_flashcard_label item, flashcard_side
		item.flashcard.sides_label[flashcard_side.to_sym].present? ? item.flashcard.sides_label[flashcard_side.to_sym] : flashcard_side.upcase # Default value 
	end


	# returns label view for flashcard
	def front_label item, i
		content_tag :div, ((item.flashcard.sides_label.present? ? item.flashcard.sides_label[:front] : 'FRONT') if item.present?) , class: ['badge badge-info front-label', i == 0  ? '' : (item.side.present? ?  'd-none' : '')]
	end	

	def back_label item, i
		content_tag :div, ((item.flashcard.sides_label.present? ? item.flashcard.sides_label[:back] : 'BACK') if item.present?), class: ['badge badge-info back-label', i == 0 ? '' : 'd-none']
	end

	def side_label item, i
		if !item.nil? and item.side.present?
			content_tag :div, ((item.flashcard.sides_label.present? ? item.flashcard.sides_label[:side] : 'SIDE') if item.present?), class: ['badge badge-info side-label', i == 0 ? '' : 'd-none']
		end	
	end
	#		


	# returns order w.r.t attachment sides for user view
	def flashcard_items_order attachment_side
	  if (attachment_side.present? and params.present?) || !attachment_side.nil?
	      arr = ((params[:front].present? and params[:back].present? and params[:side].present?)  and [params[:back], params[:side], params[:front]] ) || [:side, :front, :back]  if attachment_side == 'front'
	      arr = ((params[:front].present? and params[:back].present? and params[:side].present?)  and [params[:front], params[:side], params[:back]]) || [:front, :side, :back] if attachment_side == 'back'
	      arr = ((params[:front].present? and params[:back].present? and params[:side].present?)  and [params[:front], params[:back], params[:side]]) || [:front, :back, :side] if attachment_side == 'side'
	      arr.freeze
	  else
	    default_items_order
	  end
	end


	# returns order w.r.t attached side to manage form fields, visible to Admins, PMs, 
  	def manage_order sides_label, attachment_side
  		if attachment_side.present? and sides_label.present?
			arr = [sides_label[:side], sides_label[:front], sides_label[:back]] if attachment_side == 'front'
			arr = [sides_label[:front], sides_label[:side], sides_label[:back]] if attachment_side == 'back'
			arr = [sides_label[:front], sides_label[:back], sides_label[:side]] if attachment_side == 'side'
	  		
	  		arr.freeze
	  	end	
  	end	


  	#return order of flashcard items w.r.t sides count (i.e either flashcard is 2 sided or 3 sided)
  	def get_ordered_flashcard_sides flashcard
  		if flashcard.present?
  			if flashcard.sides_count == "3" && flashcard.sides_count.present?
  				return flashcard_items_order flashcard.attachment_side
  			elsif flashcard.sides_count == "2" && flashcard.sides_count.present?
  				return two_sided_flashcard_order	
  			end	
  		end
  	end


  	def default_items_order
  		arr = [:front, :back, :side]
  		arr.freeze
  	end

  	def two_sided_flashcard_order
  		arr = [:front, :back]
  		arr.freeze		
  	end
		
end
