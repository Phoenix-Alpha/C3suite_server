class Bundle < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  
  validates :title, presence: true, uniqueness: true
  validates :price, presence: true
  validates :products, presence: true
  
  serialize :app, Hash
  serialize :products, Array

  has_many :bundle_subscriptions, dependent: :destroy
  has_many :bundle_subscribers, through: :bundle_subscriptions, class_name: 'User', foreign_key: :user_id, source: :user
  has_many :bundle_assets

  def image(kind)
    search = AssetKind.kinds(kind)
    
    source = nil
    search.each do |s|
      item = self.bundle_assets.find_by(kind: s)
      source = item.source_url if item.present?
      break unless source.nil?
    end
    if Rails.env.production?
      # FIXME: Temporary fix to run on production. See why root_url is undefined here?
      return  source.nil? ? 'http://23.20.37.229/images/placeholder.png' : source
      # return  source.nil? ? root_url(host: '23.20.37.229')+'/images/placeholder.png' : source
    else
      return source.nil? ? '/images/placeholder.png' : source
    end
  end

  def bundled_products
    products = Product.where(id: self.products) if self.products.present?
    products or []
  end
end
