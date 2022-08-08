module ManageHelper
  def user_dashboard_link
    if current_user.is_admin? || current_user.is_product_manager? || current_user.is_content_manager? || current_user.is_content_contributor? || current_user.is_instructor?
      link_to 'Manage Products', dashboard_path
    else
      link_to 'My Products', dashboard_path
    end
  end
end
