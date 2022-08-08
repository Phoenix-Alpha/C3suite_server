class CreateBundleAssets < ActiveRecord::Migration[5.2]
  def change
    create_table :bundle_assets do |t|
      t.string :description
      t.bigint :product_id
      t.integer :kind
      t.boolean :active
      t.text :source_data

      t.timestamps
    end
  end
end
