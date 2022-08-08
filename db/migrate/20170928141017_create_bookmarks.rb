class CreateBookmarks < ActiveRecord::Migration[5.1]
  def change
    create_table :bookmarks do |t|
      t.references :user, foreign_key: true
      t.references :content, foreign_key: true
      t.string :content_type
      t.integer :content_type_id

      t.timestamps
    end
  end
end
