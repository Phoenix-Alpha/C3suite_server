class CreateContentAssets < ActiveRecord::Migration[5.1]
  def change
    create_table :content_assets do |t|
      t.string :uri
      t.integer :kind
      t.string :description

      t.timestamps
    end
  end
end
