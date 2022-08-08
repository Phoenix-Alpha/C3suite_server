class UsersController < ApplicationController
  before_action :configure_sign_in_params, only: [:create]
  before_action :set_user, only: [:show]

  def index
  end

  def show
  end

  private
    def set_user
      @user = User.find(params[:id])
    end
  end
