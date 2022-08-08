class Manage::SubmodulesController < Manage::BaseController
  before_action :set_content, except: [:destroy]
  load_and_authorize_resource :product

  def index
  end

  def show
  end

  def new
  end
  
  def edit
  end

  def create
  	if @submodule.save
  	  redirect_to manage_product_submodule_url(@product, @submodule), notice: 'Sub Module was successfully created'
  	else
      # persist content if the form validation fails
      @content ||= Content.find(submodule_params[:parent_id].to_i) if submodule_params[:parent_id].present?
  		render action: :new
  	end
  end

  def update
  	if @submodule.update(submodule_params)
  		redirect_to	manage_product_submodule_url(@product, @submodule), notice: 'Sub Module was successfully updated.'
  	else
  		render action: :edit
  	end
  end

  def destroy
    @submodule.destroy
    redirect_to manage_product_url(@product), notice: 'Module was successfully destroyed.'
  end

  private
  def set_content
    @content ||= Content.find(params[:content_id]) if params[:content_id].present?
  end

  def submodule_params
  	params.require(:submodule).permit(:title, :parent_id, :product_id)
  end
end
