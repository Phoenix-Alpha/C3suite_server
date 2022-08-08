class ApplicationController < ActionController::Base
  before_action :store_user_location!, if: :storable_location?
  protect_from_forgery with: :exception, prepend: true
  rescue_from ActiveRecord::RecordNotFound, :with => :handle_not_found

  # Paper Trail Tracking
  before_action :set_paper_trail_whodunnit

  include Response
  include ExceptionHandler

  # Catch all CanCan errors and alert the user of the exception
  rescue_from CanCan::AccessDenied do | exception |
    redirect_to root_url, alert: exception.message
  end

  def handle_not_found
    render file: "#{Rails.root}/public/404.html", layout: false, status: 404
  end

  def action_missing(m, *args, &block)
    handle_not_found
  end

  private

  # Check for valid request token and return user
  def authorize_request
    @current_user = (AuthorizeApiRequest.new(request.headers).call)[:user]
  end

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr? 
  end

  # Store User location for post-sign-in redirection
  def store_user_location!
    store_location_for(:user, request.fullpath)
  end
end
