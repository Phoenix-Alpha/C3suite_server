module ProductsHelper
  include ContentsHelper
  # Get all the non-manage users who aren't contributing to this product
  def non_contributing_users pid
    users = User.permitted_users
    users.present? ? users.pluck(:username, :id) : []
  end

  def contents_to_array perm_id
    # TODO: This is a tmp solution. Find a better way.
    perm = Permission.where(id: perm_id) if perm_id.to_i > 0
    contents = perm.first.contents if perm.present?

    contents && contents.reject(&:empty?)
  end

  def auditables content
    auditables = content.collect do |mod| 
      configurations = (get_module_configurations mod)[:configurations]
      mod if (configurations.present? and configurations[:auditable])   
    end
    auditables.compact
    
  end

  def modulee_progress modulee
    if modulee.present?
      total = modulee.children.count
      viewed = 0
      modulee.children.each do |content|
        if content.actable_type == 'Flashcard' or content.actable_type == 'Quiz'
          viewed += show_progress content
        elsif content.actable_type == 'Media'
          viewed += 1 if (viewed_media content) == 'Completed'
        elsif content.actable_type == 'Html'
          viewed += 1 if (viewed_html content) == 'Completed'
        elsif content.actable_type == 'Submodule'
          viewed += modulee_progress content
        end
      end
      total > 0 ? (viewed / total).to_i : 0 
    end
  end

  def have_permitted_product? product_id
    if current_user
      current_user.product_ids.include? product_id if product_id.present?
    end  
  end
  
  def is_subscribed product_id
    is_subscribed = ((current_user.subscribed_products.where(id: product_id)).present? or (current_user.products.where(id: product_id)).present?) ? true : false
  end
end
