module Manage::BundlesHelper
	def bundleable_products bundle
		# bundled = Bundle.where.not(id: bundle.id).pluck(:products).flatten if bundle.present?
		(Product.all.collect{ |product| [product.title, product.id] }).compact
	end

	def bundled_products bundle
		if bundle.present?
			products = bundle.products
			(products.each{ |product_id| Product.exists?(id: product_id) ? product_id : bundle.products.delete(product_id) })
			bundle.save
			return bundle.products
		end
	end
end
