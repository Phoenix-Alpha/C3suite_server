class AddSlugToBundles < ActiveRecord::Migration[5.2]
  def change
    add_column :bundles, :slug, :string
    add_index :bundles, :slug, unique: true
  end
end
