class RemoveUncessaryCkeditorPayolaTables < ActiveRecord::Migration[5.1]
  def change
    drop_table :ckeditor_assets if table_exists? :ckeditor_assets
    drop_table :payola_affiliates if table_exists? :payola_affiliates
    drop_table :payola_coupons if table_exists? :payola_coupons
    drop_table :payola_stripe_webhooks if table_exists? :payola_stripe_webhooks
    drop_table :payola_sales if table_exists? :payola_sales
    drop_table :payola_subscriptions if table_exists? :payola_subscriptions
  end
end
