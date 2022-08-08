class ProductsController < ApplicationController
  include ProductsHelper
  include ContentsHelper

  before_action :set_product, only: [:show, :subscribe, :subscription_success, :subscription_failed, :create_checkout_session]
  before_action :set_breadcrumbs

  layout 'product/dashboard'

  def show
    session[:selected] = ""
    modules = Content.rank(:row_order).where(product: @product, actable_type: "Modulee")

    @auditables = auditables modules if modules.present?
  end

  def create_checkout_session
    customer = find_or_create_customer
    product = find_or_create_product
    checkout_session = nil
    if customer.present? and product.present?
      begin
        checkout_session = StripeAPI.create_checkout_session customer, product.stripe[:price_id], subscription_success_product_url(@product), subscription_failed_product_url(@product)
        session[:product_checkout_session] = checkout_session.id if checkout_session.present?
      rescue Stripe::InvalidRequestError => e
        return render json: { error: e.message }
      rescue Stripe::StripeError => e
        return render json: { error: e.message }
      end
    end
    
    render json: { session: checkout_session }
  end

  def subscription_success
    sub = UserSubscription.find_or_create_by(user: current_user, product: @product, transaction_id: session[:product_checkout_session].present? ? session[:product_checkout_session] : nil )
    sub.save!

    redirect_to product_path(@product), notice: 'Payment processed successfully!'
  end

  def subscription_failed
    redirect_to product_path(@product), alert: 'Error while processing payment!'
  end

  private
    def set_product
      @product = Product.friendly.find(params[:id])
    end

    def set_breadcrumbs
      add_breadcrumb "Home", dashboard_path
      add_breadcrumb @product.title, product_path(@product)
    end

    def find_or_create_product
      product = @product if @product.stripe.present? and @product.stripe[:price_id].present?
      stripe_product = StripeAPI.retrieve_product(product.stripe[:product_id])
      unless product.present? and stripe_product.present?
        stripe = StripeAPI.create_product @product
        @product.stripe = stripe if stripe.present?
        product = @product if @product.save!
      end
      product
    end

    def find_or_create_customer
      customer_id = current_user.stripe_customer_id
      customer = StripeAPI.retrieve_customer(customer_id) # check if customer id is valid on stripe
      
      unless customer_id.present? and customer.present?
        customer = StripeAPI.create_customer current_user.email, ENV['STRIPE_PUBLISHABLE_KEY']
        ((current_user.stripe_customer_id = customer.id) and current_user.save) if customer.id.present?
      end

      current_user
    end
end
