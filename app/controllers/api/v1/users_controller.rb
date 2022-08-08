class API::V1::UsersController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authorize_request, except: [:token, :create, :forgot_password, :reset_password]
  
  def token
    auth_token = JsonWebToken.encode(user_id: user.id) if user
    if auth_token.present?
      json_response({success: true, auth_token: auth_token, user: user}) 
    else
      json_response({success: false})
    end
  end

  def create
    user = User.new(user_params)
    if user.save
      json_response({ success: true })
    else
      json_response({ success: false, message: (user.errors.full_messages.join(', ') if user.errors.present?) })
    end
  end

  def change_password
    if user_password_update_params and @current_user.update(user_password_update_params)
      json_response({ success: true })
    else
      raise(ActiveRecord::RecordInvalid, @current_user)
    end
  end

  def change_email
    if user_email_update_params and @current_user.update(user_email_update_params)
      json_response({ success: true })
    else
      json_response({ success: false, message: (@current_user.errors.present? ? @current_user.errors.full_messages.join(', ') : 'Email update failed' ) })
    end
  end

  def forgot_password
    user = User.find_by(email: params[:email]) if params[:email].present?
    if user.present?
      mail = UserMailer.instructions_for_password_reset(user).deliver
      if mail.present? and mail.errors.blank?
        json_response({success: true, perform_deliveries: mail.perform_deliveries, header: mail.header})
      else
        json_response({success: false, message: mail.errors.present? ? mail.errors : "Email was not sent succesfully." })
      end
    else
      raise(ActiveRecord::RecordInvalid)
    end
  end

  def reset_password
    user = User.reset_password_by_token(reset_password_params) # When token doesn't match, User object with nil values is returned.
    if User.exists?(user.id) and user.save
      json_response({success: true})
    else
      raise(ExceptionHandler::BadRequest, user.errors.present? ? user.errors.full_messages : Message.missing_parameters)
    end
  end

  private

  attr_reader :email, :password

  def auth_params
    params.permit(:email, :password)
  end

  def user
    user = User.find_by(email: auth_params[:email])
    return user if user && user.valid_password?(auth_params[:password])
    # raise Authentication error if credentials are invalid
    raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
  end

  def user_email_update_params
    new_params = params.permit(:email)
    return new_params if new_params.present? and @current_user.present? and @current_user.valid_password?(params[:password])
    raise(ExceptionHandler::AuthenticationError, Message.unauthorized) if @current_user.blank?
    raise(ExceptionHandler::BadRequest, Message.missing_parameters) unless new_params.present?
    raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials) unless @current_user.valid_password?(params[:password])
  end

  def user_password_update_params
    new_params = params.permit(:password, :password_confirmation)
    return new_params if new_params.present? and @current_user.present? and @current_user.valid_password?(params[:current_password])
    raise(ExceptionHandler::AuthenticationError, Message.unauthorized) if @current_user.blank?
    raise(ExceptionHandler::BadRequest, Message.missing_parameters) unless new_params.present?
    raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials) unless @current_user.valid_password?(params[:current_password])
  end

  def reset_password_params
    new_params = params.permit(:reset_password_token, :password, :password_confirmation)
    return new_params if new_params.present?
    raise(ExceptionHandler::BadRequest, Message.missing_parameters) unless new_params.present?
  end

  def user_params
    new_params = params.permit(:username, :email, :password, :password_confirmation)
    return new_params if new_params.present?
    raise(ExceptionHandler::BadRequest, Message.missing_parameters) unless new_params.present?
  end


 
end