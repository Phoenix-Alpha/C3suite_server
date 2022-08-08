class Manage::RolesController < Manage::BaseController
  before_action :set_role, only: [:show]

  def show
  end

  private
    def set_role
      @role = Role.find(params[:id])
    end

    def role_params
      params.fetch(:role).permit(:name)
    end
end
