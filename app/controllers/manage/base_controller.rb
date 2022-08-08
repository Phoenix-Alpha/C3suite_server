class Manage::BaseController < ApplicationController
  load_and_authorize_resource
  before_action :set_content_id

  private
  def set_content_id
    session[:parent_content_id] = params[:content_id] if params[:content_id].present?
  end
end
