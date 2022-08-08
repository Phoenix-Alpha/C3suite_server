module Manage::ContentsHelper

  def content_method content
    public_send("manage_product_#{content.actable_type.downcase}_path", product_id: content.product, id: content.actable_id) if content.product.present?
  end

end
