class Manage::BundleAssetsController < Manage::BaseController
    before_action :set_bundle_asset, only: [:show, :edit, :update, :destroy, :create, :new]
    load_and_authorize_resource :bundle
    
    def index
      @assets = @bundle.bundle_assets
    end
  
    def show
    end
  
    def new
    end
    
    def edit
    end
  
    def create
      if @asset.save
        redirect_to manage_bundle_bundle_asset_url(@bundle, @asset), notice: 'Asset was successfully created'
      else
        render action: :new
      end
    end
  
    def update
      if @asset.update(bundle_asset_params)
        redirect_to manage_bundle_bundle_asset_url(@bundle, @asset), notice: 'Asset was successfully updated.'
      else
        render action: :edit
      end
    end
  
    def destroy
      @asset.remove_source
      @asset.destroy
      respond_to do |format|
        format.html { redirect_to manage_bundle_bundle_assets_url, notice: 'Asset was successfully destroyed.' }
      end
    end
  
    private
  
    def set_bundle_asset
      @asset = @bundle_asset #bundleAsset.find(params[:id])
    end
  
    def bundle_asset_params
      params.require(:bundle_asset).permit(:description, :source, :kind, :bundle_id, :active)
    end
end
