class CreateBuildTests < ActiveRecord::Migration[6.0]
  def change
    create_table :build_tests do |t|
      t.references :user, null: false, foreign_key: true
      t.text :chapter_ids
      t.string :content_type
      t.string :no_of_items
      t.references :content, null: false, foreign_key: true
      t.text :content_type_ids

      t.timestamps
    end
  end
end
