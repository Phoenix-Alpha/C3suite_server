class DashboardController < ApplicationController
  include BundlesHelper

  def index
    @bundles = Bundle.all
    @products = {}
    if current_user
      @products[:available] = Product.all || []
      @products[:personal] = (current_user.subscribed_products + current_user.products).uniq || []      # user has-many products through permissions             
      @products[:available]-=@products[:personal]
    else
      @products[:available] = Product.where(visibility: Product::VISIBILITY_ALL)
    end
  end

  def purchases
    customer_id = current_user.stripe_customer_id
    customer = StripeAPI.retrieve_customer(customer_id) if customer_id.present?
    @charges = Stripe::Charge.list(customer: current_user.stripe_customer_id) unless current_user.stripe_customer_id.blank? or customer.blank?
    @charges || []
  end
end
