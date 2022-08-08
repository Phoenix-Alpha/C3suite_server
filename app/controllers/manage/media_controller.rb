class Manage::MediaController < Manage::BaseController
  before_action :set_content, except: [:destroy]
  load_and_authorize_resource :product

  def show
  end

  def new
  end
  
  def edit
  end

  def create
    if @media.save
      redirect_to manage_product_url(@product), notice: "#{@media.local_type.capitalize} content was successfully created"
    else
      # persist content if the form validation fails
      @content ||= Content.find(media_params[:parent_id].to_i) if media_params[:parent_id].present?
      render action: :new
    end
  end

  def update
    if @media.update(media_params)
      redirect_to manage_product_url(@product), notice: "#{@media.local_type.capitalize} content was successfully updated."
    else
      render action: :edit
    end
  end

  def destroy
    @media.destroy
    redirect_to manage_product_url(@product), notice: 'Media was successfully destroyed.'
  end

  private
  def set_content
    @content ||= Content.find(params[:content_id]) if params[:content_id].present?
  end

  def media_params
    params.require(:media).permit(:local_type, :title, :source, :caption, :transcript, :duration, :thumbnail_url, :parent_id, :product_id)
  end

end
