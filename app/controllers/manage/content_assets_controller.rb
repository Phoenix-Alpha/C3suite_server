class Manage::ContentAssetsController < ApplicationController
  before_action :set_content_asset, only: [:show, :edit, :update, :destroy]
  before_action :set_content, except: [:destroy]
  load_and_authorize_resource :product

  def index
    @assets = ContentAsset.where(content_id: @content.id) if @content.present?
    @assets ||= []
  end

  def show
  end

  def new
    @asset = ContentAsset.new(content_id: @content.id) if @content.present?
    @asset ||= ContentAsset.new
  end
  
  def edit
  end

  def create
    @asset = ContentAsset.new(content_asset_params)

    if @asset.save
      redirect_to manage_content_content_asset_url(@content, @asset), notice: 'Asset was successfully created'
    else
      render action: :new
    end
  end

  def update
    if @asset.update(content_asset_params)
      redirect_to manage_content_content_asset_url(@content, @asset), notice: 'Asset was successfully updated.'
    else
      render action: :edit
    end
  end

  def destroy
    # TODO: Confirm if destroying the assets (automatically) destroys the source too
    @asset.remove_source
    @asset.destroy
    respond_to do |format|
      format.html { redirect_to manage_content_content_assets_url, notice: 'Asset was successfully destroyed.' }
    end
  end

  private

  def set_content_asset
    @asset = ContentAsset.find(params[:id])
  end

  def set_content
    @content = Content.find(params[:content_id])
  end

  def content_asset_params
    params.require(:content_asset).permit(:description, :source, :kind, :content_id, :active)
  end
end
