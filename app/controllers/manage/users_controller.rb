class Manage::UsersController < Manage::BaseController
  skip_authorize_resource :only => [:edit, :update]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
  	@users = User.all
  end

  def show
  end

  def new
    @user = User.new
    if current_user.is_admin?
      @roles = Role.all.pluck(:name, :id)
    elsif current_user.is_product_manager?
      @roles = Role.where(name: [User::PRODUCT_MANAGER, User::CONTENT_CONTRIBUTOR]).pluck(:name, :id)
    end
  end

  def edit
    @user_roles = @user.roles.map(&:name)
    if current_user.is_admin?
      @roles = Role.all.pluck(:name, :id)
      @value = false
    elsif current_user.is_product_manager?
      @roles = Role.where(:name=>['Content Contributor','Instructor']).pluck(:name, :id)
      @value = true
    else
      @value = true
    end
  end

  def create
    @user = User.new(user_params)
    @user.roles = roles

    if @user.save
      redirect_to manage_user_url(@user), notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def update
    # New to-be-added user roles
    if !@user.is_admin?
      @user.user_roles = roles.collect { |r| UserRole.find_or_create_by(user_id: @user.id, role_id: r.id) }
    end
      

    respond_to do |format|
      if (password_unchanged? && @user.update_without_password(user_params)) || @user.update(user_params)
        format.html { redirect_to manage_user_url(@user), notice: 'User was successfully updated.' }
      else
        @roles = Role.all.pluck(:name, :id)
        format.html { render :edit }
      end
    end
  
  end

  #TODO
  
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to manage_users_url, notice: 'User was successfully destroyed.' }
    end
  end

  def get_user_roles
    return if !current_user
      user_id = params[:id].to_i if params[:id].present?
      
      roles = User.find(user_id).roles if user_id > 0
      roles = roles.pluck(:id, :name) if roles.count > 0

      render json: roles || []
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      new_params = params.require(:user).permit(:username, :email, :password, :password_confirmation)

      if new_params[:password].blank? && new_params[:password_confirmation].blank?
          new_params.delete(:password)
          new_params.delete(:password_confirmation)
      end

      new_params
    end

    def roles
      params[:roles].collect { |id| Role.where(id: id).first }.compact unless params[:roles].blank?
    end

    def password_unchanged?
      user_params[:password].blank?
    end
end
