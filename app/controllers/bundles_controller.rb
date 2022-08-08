class BundlesController < ApplicationController
  before_action :set_bundle, only: [:show, :subscribe]
  	#before_action :set_breadcrumbs
  def show
		if @bundle.present?
	  		@products = []
	  		@bundle.products.each do |product_id|
	  			@products.push(Product.find(product_id)) if product_id.present? and Product.exists?(id: product_id)
	  		end
  		end
	end

  def subscribe
    if user_signed_in?
      price = @bundle.price.to_i * 100

      customer_id = find_or_create_customer

      if customer_id.present?
        # Add / update customer stripe id
        u = current_user
        (u.stripe_customer_id = customer_id) && u.save! unless u.stripe_customer_id.present?

        charge = StripeAPI.create_charge customer_id, price, @bundle.title
      end

      if charge.present? && charge.paid

        bundle_sub = BundleSubscription.find_or_create_by(user: current_user, bundle: @bundle)
        bundle_sub.save!
        @bundle.products.each do |product_id|
          if product_id.present?
            product = Product.find(product_id) if Product.exists?(id: product_id)
            product_sub = UserSubscription.find_or_create_by(user: current_user, product: product)
            product_sub.save!
          end
        end
        redirect_to bundle_path(@bundle), notice: 'Payment processed successfully!'
      else
        redirect_to bundle_path(@bundle), notice: 'Error while processing payment!'
      end

    else
      redirect_to new_user_session_path, notice: 'Please sign in to continue.'
    end

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to bundle_path(@bundle)
  end

	private
	def set_bundle
		@bundle = Bundle.friendly.find(params[:id])
	end

  def find_or_create_customer
    customer_id = current_user.stripe_customer_id

    unless customer_id.present?
      customer = StripeAPI.create_customer params[:stripeEmail], params[:stripeToken]
    end

    customer_id || customer.id
  end
end
