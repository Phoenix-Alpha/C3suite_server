class ProductSerializer < ActiveModel::Serializer
  include ActionView::Helpers::TextHelper
  attributes :id, :title, :icon, :created_at, :updated_at, :visibility, :tagline, :description, :pricing_model, :frequency, :price, :slug, :tags, :configurations, :background, :image, :app_store_iaps, :app_store_bundle_id

  def background
    self.object.background_data.present? ? self.object.background_url : ''
  end

  def description
    strip_tags(self.object.html_description)
  end

  def image
    self.object.image('square')
  end

  def app_store_bundle_id
    self.object.app_store_bundle_id
  end

  def app_store_iaps
    return nil if !self.object.app.present?
    self.object.app[:iaps]
  end
end
