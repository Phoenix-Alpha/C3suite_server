class Manage::BundlesController < Manage::BaseController
  include ProductsHelper
  before_action :set_bundle, only: [:app_store, :create_app, :create_iap, :edit_iap, :update_iap, :delete_iap]

  def index
  	if current_user.present? and current_user.is_admin?
  		@bundle = Bundle.all
	end
  end

  def show  		
  	if @bundle.present?
  		@products = []
  		@bundle.products.each do |product_id|
  			@products.push(Product.find(product_id)) if product_id.present? and Product.exists?(id: product_id)
  		end
  	end	
  end  

  def new
  end

  def edit
  end

  def create
    app = true
    app_store = nil
    if bundle_params[:app_store_bundle_id].present?
      app_store = AppStore.new
      app = app_store.find_app bundle_params[:app_store_bundle_id] # returns false if no app found
    end
    if app and @bundle.save
      @bundle.app = app if bundle_params[:app_store_bundle_id].present?
    	redirect_to manage_bundle_url(@bundle), notice: 'Bundle was created successfully.' if @bundle.save
  	elsif app_store.errors.present?
      format.html { redirect_to request.referrer, alert: app_store.errors }
    else
    	render :new
  	end
  end

  def update
    app = true
    app_store = nil
    if bundle_params[:app_store_bundle_id].present?
      app_store = AppStore.new
      app = app_store.find_app bundle_params[:app_store_bundle_id] # returns false if no app found
    end
    if app and @bundle.update(bundle_params)
      @bundle.app = app if bundle_params[:app_store_bundle_id].present?
      if @bundle.save
        redirect_to manage_bundle_url(@bundle), notice: 'Bundle was updated successfully.'
      end
    else
      if app_store.errors.present?
        format.html { redirect_to request.referrer, alert: app_store.errors }
      else
        render :edit
      end
    end
  end

  def destroy
    @bundle.destroy
    redirect_to manage_bundles_path, notice: 'Product was successfully destroyed.'
  end

  def app_store
    @app = @bundle.app if @bundle.app_store_bundle_id.present? and @bundle.app.present?
  end

  def create_app
    app = AppStore.new
    if(app.create_app params)
      @bundle.app = {
        name: params[:app_name],
        vendor_id: params[:sku],
        bundle_id: params[:app_store_bundle_id],
        iaps: []
      }
      @bundle.app_store_bundle_id = params[:app_store_bundle_id]
      @bundle.save
      redirect_to manage_bundle_url(@bundle), notice: "App store Application created successfully against bundle: '#{@bundle.title}'."
    else
      redirect_to request.referrer, alert: app.errors
    end 
  end

  def create_iap
    app = AppStore.new
    if(app.create_iap params, @bundle.app_store_bundle_id)
      @bundle.app[:iaps].push({reference_name: params[:reference_name], product_id: params[:iap_id], tier: params[:price].to_i}) if @bundle.app.present?
      redirect_to manage_bundle_app_store_path(@bundle), notice: "In-App Purchase created successfully." if @bundle.save
    else
      redirect_to request.referrer, alert: app.errors
    end
  end

  def edit_iap
    app = AppStore.new
    @iap = (app.find_iap params[:iap_id], @bundle.app_store_bundle_id) if @bundle.app_store_bundle_id.present?
    @iap = @iap.edit if @iap.present?
    redirect_to request.referrer, alert: app.errors unless @iap.present?
  end

  def update_iap
    app = AppStore.new
    if(app.update_iap params, @bundle.app_store_bundle_id)
      app = app.find_app @bundle.app_store_bundle_id
      @bundle.app = app if app.present?
      redirect_to manage_bundle_app_store_path(@bundle), notice: "In-App Purchase updated successfully." if @bundle.save
    else
      redirect_to request.referrer, alert: app.errors
    end
  end

  def delete_iap
    app = AppStore.new
    if(app.delete_iap params[:iap_id], @bundle.app_store_bundle_id)
      app = app.find_app @bundle.app_store_bundle_id
      @bundle.app = app if app.present?
      redirect_to manage_bundle_app_store_path(@bundle), notice: "In-App Purchase deleted successfully." if @bundle.save
    else
      redirect_to request.referrer, alert: app.errors
    end
  end



  private
  def bundle_params
  	params.fetch(:bundle).permit(:title, :description, :price, :allow_single_product_subscription, :app_store_bundle_id,
      products: [])
  end

  def set_bundle
    @bundle = Bundle.friendly.find(params[:bundle_id])
  end

end
