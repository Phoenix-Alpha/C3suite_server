class Manage::ProductAssetsController < Manage::BaseController
  before_action :set_product_asset, only: [:show, :edit, :update, :destroy, :create, :new]
  load_and_authorize_resource :product
  
  def index
    @assets = @product.product_assets
  end

  def show
  end

  def new
  end
  
  def edit
  end

  def create
    if @asset.save
      redirect_to manage_product_product_asset_url(@product, @asset), notice: 'Asset was successfully created'
    else
      render action: :new
    end
  end

  def update
    if @asset.update(product_asset_params)
      redirect_to manage_product_product_asset_url(@product, @asset), notice: 'Asset was successfully updated.'
    else
      render action: :edit
    end
  end

  def destroy
    # TODO: Confirm if destroying the assets (automatically) destroys the source too
    @asset.remove_source
    @asset.destroy
    respond_to do |format|
      format.html { redirect_to manage_product_product_assets_url, notice: 'Asset was successfully destroyed.' }
    end
  end

  private

  def set_product_asset
    @asset = @product_asset #ProductAsset.find(params[:id])
  end

  def product_asset_params
    params.require(:product_asset).permit(:description, :source, :kind, :product_id, :active)
  end
end
