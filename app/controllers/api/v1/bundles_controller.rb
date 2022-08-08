class API::V1::BundlesController < ApplicationController
    include ActionView::Helpers::TextHelper
    before_action :set_bundle, only: [:show, :subscribe]
    before_action :authorize_request, only: [:subscribe]
    before_action :authorize_request, only: [:create_auto_product_subscription]
  
    def show
      authorize_request
      rescue StandardError => e
        p e.message
      ensure
        products = (@bundle.products || []).compact.reject(&:empty?)
        subscribed_products = (@current_user.present? and products.present?) ? UserSubscription.filter_by_subscription(@current_user, products) : []
        unsubscribed_products = products - subscribed_products
        
        #TODO: Double check and fix (if not handled) that, if a product is deleted its id should not exist in bundled products column
        bundle = OpenStruct.new()
        
        app_store_bundle = get_app_store_bundle
        @bundle.attributes.each do |key, value|  
          if key == "description" 
            bundle[key.to_sym] = strip_tags(value) 
          elsif key == "app"
            bundle[:app_store_iaps] = value[:iaps]
          else
            bundle[key.to_sym]  = value
          end
        end
        
        bundle[:subscribed] = ActiveModel::Serializer::ArraySerializer.new(Product.find(subscribed_products), each_serializer: ProductSerializer) if subscribed_products.present? and  Product.exists?(id: subscribed_products)
        bundle[:unsubscribed] = ActiveModel::Serializer::ArraySerializer.new(Product.find(unsubscribed_products), each_serializer: ProductSerializer) if unsubscribed_products.present? and Product.exists?(id: unsubscribed_products)
        json_response({success: true, bundle: bundle.marshal_dump, user: @current_user})
      
    end

    def subscribe
      
      success = false
      return if !@current_user
      if params # and params[:charge].present?
    
        bundle_sub = BundleSubscription.find_or_create_by(user: @current_user, bundle: @bundle)
        if bundle_sub.save!
          @bundle.products.each do |product_id|
            if product_id.present?
              product = Product.find(product_id) if Product.exists?(id: product_id)
              product_sub = UserSubscription.find_or_create_by(user: @current_user, product: product)
              product_sub.save!
            end
          end
          success = true
        end
        render json: {success: success}  
      else
        render json: { message: 'Error while processing payment!'}
      end
    end
  
    private
  
    def set_bundle
      @bundle = Bundle.friendly.find(params[:id]) if params[:id].present?
    end

    def create_auto_subscription
      if(@bundle.price <= 0 and @current_user.present?)
        bundle_sub = BundleSubscription.find_or_create_by(user: @current_user, bundle: @bundle)
        if bundle_sub.save!
          products = (@bundle.products || []).compact.reject(&:empty?)
          products = Product.where(id: products)
          products.each do |product|
              sub = UserSubscription.find_or_create_by(user: @current_user, product: product)
              sub.save!
          end
        end
      end
    end

    def get_app_store_bundle
      app = AppStore.new
      application = app.find_bundle @bundle.app_store_bundle_id if app.present?
      # application.in_app_purchases.all.collect{ |p| { product_id: p.product_id, tier: p.edit.pricing_intervals.first[:tier] }} if application.present?
    end
  end