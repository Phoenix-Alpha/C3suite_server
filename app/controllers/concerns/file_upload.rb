module FileUpload
  def upload
    @content_id = session[:parent_content_id] if session[:parent_content_id].present?
  end
end