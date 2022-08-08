class AddColumnStripeInProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :stripe, :text
  end
end
