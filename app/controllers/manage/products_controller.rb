class Manage::ProductsController < Manage::BaseController
  before_action :set_product, only: [:app_store, :create_iap, :delete_iap, :edit_iap, :update_iap, :create_app]
  def index
    if current_user.is_admin?
    else
      @products = current_user.products
    end
  end

  def show
    @contents = Content.rank(:row_order).where(:product_id => @product).roots
    @rowarray = session[:rowarray]
    @values = session[:array]
  end

  def new
  end

  def edit
    @contents = Content.all
    @configs = @product.configurations
    @product_managers = @product.users.pluck(:email) unless @product.users.empty?
  end

  def create
    app = true
    app_store = nil
    if product_params[:app_store_bundle_id].present?
      app_store = AppStore.new
      app = app_store.find_app product_params[:app_store_bundle_id] # returns false if no app found
    end

    begin
      stripe = StripeAPI.create_product @product
    rescue Stripe::InvalidRequestError => e
      return redirect_to request.referrer, alert: e.message
    rescue Stripe::StripeError => e
      return redirect_to request.referrer, alert: e.message
    end

    respond_to do |format|
      @product.stripe = stripe if stripe.present?
      if app and @product.save
        @product.app = app if product_params[:app_store_bundle_id].present?
        format.html { redirect_to manage_product_url(@product), notice: 'Product was successfully created.' } if @product.save
      elsif app_store.present? and app_store.errors.present?
        format.html { redirect_to request.referrer, alert: app_store.errors }
      else
        format.html { render :new }
      end
    end
  end

  def update
    app = true
    app_store = nil
    if product_params[:app_store_bundle_id].present?
      app_store = AppStore.new
      app = app_store.find_app product_params[:app_store_bundle_id] # returns false if no app found
    end
    respond_to do |format|
      begin
        stripe = update_stripe_product product_params
      rescue Stripe::InvalidRequestError => e
        return redirect_to request.referrer, alert: e.message
      rescue Stripe::StripeError => e
        return redirect_to request.referrer, alert: e.message
      end
      
      if app and @product.update(product_params)
        @product.app = app if product_params[:app_store_bundle_id].present?
        @product.configurations = get_configurations params
        @product.stripe = stripe if stripe.present?
        if @product.save
          format.html { redirect_to manage_product_url(@product), notice: 'Product was successfully updated.' }
        end
      else
        if params[:commit]  == "Update Product Permissions"
          format.html { render :permissions }
        elsif app_store.errors.present?
          format.html { redirect_to request.referrer, alert: app_store.errors }
        else
          format.html { render :edit }
        end  
      end
    end
  end

  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to manage_products_url, notice: 'Product was successfully destroyed.' }
    end
  end

  def permissions
    @permissions = @product.permissions
  end

  def contents
    contents = [] #only contains 'Modules' and 'Sub modules'

    if @product.present?
      contents = Content.where(product: @product).roots.map do |content|
        obj = [{ id: content.id, text: content.title, level: 1, type:  'Module' }]

        if content.children.present?
          content.children.each do |child|
            if child.actable_type == 'Submodule'
              obj.push({ id: child.id, text: child.title, type: child.actable_type, level: 2 })
            end
          end
        end

        obj
      end
    end

    render json: { results: contents.flatten }
  end

  def import
    if params[:upload_type] == 'quiz'
      @product.import_quizzes(params[:file], params[:content_id])
    elsif params[:upload_type] == 'flashcard'
      @product.import_flashcards(params[:file], params[:content_id])
    else
      @product.import_htmls(params[:files], params[:content_id])
    end

    redirect_to manage_product_url(@product)
  end

  def app_store
    @app = @product.app if @product.app_store_bundle_id.present? and @product.app.present?
  end

  def create_app
    app = AppStore.new
    if(app.create_app params)
      @product.app = {
        name: params[:app_name],
        vendor_id: params[:sku],
        bundle_id: params[:app_store_bundle_id],
        iaps: []
      }
      @product.app_store_bundle_id = params[:app_store_bundle_id]
      @product.save
      redirect_to manage_product_url(@product), notice: "App store Application created successfully."
    else
      redirect_to request.referrer, alert: app.errors
    end
  end

  def create_iap
    app = AppStore.new
    if(app.create_iap params, @product.app_store_bundle_id)
      success = sync_created_iaps @product.app_store_bundle_id, params if @product.app.present?
      redirect_to manage_product_app_store_path(@product), notice: "In-App Purchase created successfully." if success
    else
      redirect_to request.referrer, alert: app.errors
    end
  end

  def edit_iap
    app = AppStore.new
    @iap = (app.find_iap params[:iap_id], @product.app_store_bundle_id) if @product.app_store_bundle_id.present?
    @iap = @iap.edit if @iap.present?
    redirect_to request.referrer, alert: app.errors unless @iap.present?
  end

  def update_iap
    app = AppStore.new
    if(app.update_iap params, @product.app_store_bundle_id)
      app = app.find_app @product.app_store_bundle_id
      success = sync_updated_iaps @product.app_store_bundle_id, app if app.present?
      redirect_to manage_product_app_store_path(@product), notice: "In-App Purchase updated successfully." if success
    else
      redirect_to request.referrer, alert: app.errors
    end
  end

  def delete_iap
    app = AppStore.new
    if(app.delete_iap params[:iap_id], @product.app_store_bundle_id)
      app = app.find_app @product.app_store_bundle_id
      success = sync_updated_iaps @product.app_store_bundle_id, app if app.present?
      redirect_to manage_product_app_store_path(@product), notice: "In-App Purchase deleted successfully." if success
    else
      redirect_to request.referrer, alert: app.errors
    end
  end

  private
  def product_params
    params.fetch(:product).permit(:title, :visibility, :html_description, :price, :background, :app_store_bundle_id,
      tags: [],
      managers: [],
      permissions_attributes: [:id, :product_id, :user_id, :role_id, :_destroy, contents: []])
  end

  def set_product
    @product = Product.friendly.find(params[:product_id])
  end

  def sync_created_iaps bundle_id, params # bundle_id => app store bundle id
    success = false
    Product.all.each do |product|
      if product.app.present? and product.app[:bundle_id] == bundle_id
        product.app[:iaps].push({reference_name: params[:reference_name], product_id: params[:iap_id], tier: params[:price].to_i})
        success = true if product.save!
      end
    end
    success
  end

  def sync_updated_iaps bundle_id, app
    success = false
    return success if bundle_id.blank? or app.blank?
    Product.all.each do |product|
      if product.app.present? and product.app_store_bundle_id == bundle_id
        product.app = app
        success = true if product.save!
      end
    end
    success
  end

  def get_configurations params
    return {} if params.nil?
    cerulean = '#33c3ff'
    black = '#000000'
    configurations = { 
      background_type: params[:product][:background_type],
      view_type: params[:product][:view_type],
      colors: { 
        button: params[:product][:web_button].present? ? params[:product][:web_button] : cerulean,
        text_links: params[:product][:web_text_link].present? ? params[:product][:web_text_link] : cerulean,
        headings: params[:product][:web_headings].present? ? params[:product][:web_headings] : black,
        sub_headings: params[:product][:web_subheadings].present? ? params[:product][:web_subheadings] : black,
        primary: params[:product][:primary].present? ? params[:product][:primary] : cerulean,
        accent: params[:product][:accent].present? ? params[:product][:accent] : cerulean,
        background: params[:product][:bg_color].present? ? params[:product][:bg_color] : cerulean,
        text: params[:product][:text].present? ? params[:product][:text] : black,
      },
    }
  end

  def update_stripe_product params
    return if @product.blank? or params.blank?
    if @product.stripe.present? and @product.stripe[:product_id].present? and @product.stripe[:price_id].present?
      if params[:price] != @product.price.to_s
        price = StripeAPI.create_price @product.price, @product.stripe[:product_id]    # Note: price cannot be updates only a new price can be created
        stripe = @product.stripe
        stripe[:price_id] = price.id
        stripe
      end
    else
      stripe = StripeAPI.create_product @product
    end
  end

end
