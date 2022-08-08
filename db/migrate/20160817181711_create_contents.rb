class CreateContents < ActiveRecord::Migration[5.1]
  def change
    create_table :contents do |t|
      t.bigint :product_id
      t.integer :follows
      t.integer :parent
      t.string :kind
      t.text :payload

      t.timestamps
    end
  end
end
