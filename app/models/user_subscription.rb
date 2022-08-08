class UserSubscription < ApplicationRecord
  belongs_to :user
  belongs_to :product

  def self.subscription_current?(user, product)
    subscription = UserSubscription.where(user_id: user).where(product_id: product).take
    subscription.present? if user.present?
  end

  def self.filter_by_subscription(user, products)
    if products.present? and user.present?
      subscriptions = UserSubscription.where(user_id: user).where(product_id: products)
      subscriptions = subscriptions.pluck(:product_id).map(&:to_s) if subscriptions.present?
      subscriptions || []
    end
  end

end
