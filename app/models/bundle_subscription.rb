class BundleSubscription < ApplicationRecord
  belongs_to :user
  belongs_to :bundle

  def self.subscription_current?(user, bundle)
    subscription = BundleSubscription.where(user_id: user).where(bundle_id: bundle).take
    subscription.present? if user.present?
  end
end
