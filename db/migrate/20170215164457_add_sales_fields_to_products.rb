class AddSalesFieldsToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :tagline, :string
    add_column :products, :html_description, :text
    add_column :products, :pricing_model, :string
    add_column :products, :frequency, :int
    add_column :products, :price, :decimal, precision: 10 , scale: 2
  end
end
