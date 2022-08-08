class AddForeignkeyToContents < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :contents, :products
  end
end
