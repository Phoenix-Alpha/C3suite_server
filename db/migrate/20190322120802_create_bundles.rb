class CreateBundles < ActiveRecord::Migration[5.2]
  def change
    create_table :bundles do |t|
      t.string :title
      t.text :description
      t.text :products
      t.boolean :allow_single_product_subscription
      t.decimal :price, precision: 10, scale: 2
      t.timestamps
    end
  end
end
