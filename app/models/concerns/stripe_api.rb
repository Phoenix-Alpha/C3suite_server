module StripeAPI
  DEFAULT_CURRENCY = "usd".freeze
  @error = ''

  def self.create_customer email, token
    Stripe::Customer.create(
      email: email,
    )
  end

  def self.retrieve_customer id
    begin
      customer = Stripe::Customer.retrieve(id)
    rescue Stripe::InvalidRequestError => e
      return nil if e.code.present? and e.code == "resource_missing"
    end
  end

  def self.create_charge customer_id, amount, description
    # TODO: Use idempotent requests to avoid multiple charges
    charge = Stripe::Charge.create({
      customer: customer_id,
      amount: amount,
      currency: DEFAULT_CURRENCY,
      description: description
    })
  end

  def self.create_product product
    return if product.nil?
    stripe_product = Stripe::Product.create({
      name: product.title,
      images: Rails.env.production? ? [product.image('square')] : []
    })
    
    price = create_price product.price, stripe_product.id if stripe_product.present? and stripe_product.id

    {product_id: stripe_product.id, price_id: price.id} if stripe_product.present? and price.present?
  end

  def self.retrieve_product id
    begin
      product = Stripe::Product.retrieve(id)
    rescue Stripe::InvalidRequestError => e
      return nil if e.code.present? and e.code == "resource_missing"
    end
  end

  def self.create_price price, product_id
    return if price.nil? or product_id.nil?
    price = Stripe::Price.create({
      unit_amount: (price.to_f * 100).to_i,  # in cents, or 0 for free
      currency: DEFAULT_CURRENCY,
      product: product_id,
    })
  end

  def self.create_checkout_session customer, price_id, success_url, cancel_url
    return if customer.blank? or price_id.blank? or success_url.blank? or cancel_url.blank?
    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        price: price_id,
        quantity: 1
      }],
      customer: customer.stripe_customer_id,
      mode: 'payment',
      success_url: success_url,
      cancel_url: cancel_url
    )
  end
  
end