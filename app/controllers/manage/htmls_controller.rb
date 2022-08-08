class Manage::HtmlsController < Manage::BaseController
  include FileUpload
  
	before_action :set_content, except: [:destroy]
  load_and_authorize_resource :product

  def show
  end

  def new
  end
  
  def edit
  end

  def create
  	if @html.save
  	  redirect_to manage_product_html_url(@product, @html), notice: 'Html Content was successfully created'
  	else
      # persist content if the form validation fails
      @content ||= Content.find(html_params[:parent_id].to_i) if html_params[:parent_id].present?
  		render action: :new
  	end
  end

  def update
  	if @html.update(html_params)
  		redirect_to	manage_product_html_url(@product, @html), notice: 'Html Content was successfully updated.'
  	else
  		render action: :edit
  	end
  end

  def destroy
    @html.destroy
    redirect_to manage_product_url(@product), notice: 'Html was successfully destroyed.'
  end

  private
  def set_content
    @content ||= Content.find(params[:content_id]) if params[:content_id].present?
  end

  def html_params
  	params.require(:html).permit(:title, :description, :html_source, :parent_id, :product_id)
  end

end
