class CreateViewedContents < ActiveRecord::Migration[5.1]
  def change
    create_table :viewed_contents do |t|
      t.string :content_type
      t.string :ancestry
      t.integer :content_type_id

      t.timestamps
    end

    add_reference :viewed_contents, :users, foreign_key: true, type: :bigint
    add_reference :viewed_contents, :contents, foreign_key: true, type: :bigint
  end
end
