module BundlesHelper
	def bundleable_products
		bundled_products = Bundle.all.pluck(:products).flatten
		(Product.where(visibility: [Product::VISIBILITY_ALL, Product::VISIBILITY_REGISTERED_USERS]).collect{ |product| product if !bundled_products.include? product.id.to_s }).compact
	end
end
