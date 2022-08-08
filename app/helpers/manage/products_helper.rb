module Manage::ProductsHelper

  def content_titles contents
    contents ||= []
    contents.collect {|c| Content.find(c).title unless c.blank? }.compact
  end

  def have_manageable_product? product_id
    if current_user and current_user.is_product_manager?
      current_user.product_ids.include? product_id if product_id.present?
    end  
  end


  def iap_price_tier
    arr = (0..25).collect{ |i| [ i == 0 ? "USD 0 (Free)" : "USD #{i - 0.01} (Tier #{i})" , i] }
  end

  def price_tier
    (0..25).collect{ |i| i == 0 ? [0, 0] : [i - 0.01, i - 0.01] }
  end

  # def iap_types
  #   [
  #     ["Consumable", "comsumable"],
  #     ["Non-Consumable", ""]
  #   ]
  # end
end
