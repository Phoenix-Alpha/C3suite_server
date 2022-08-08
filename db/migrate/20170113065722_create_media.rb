class CreateMedia < ActiveRecord::Migration[5.1]
  def change
    create_table :media do |t|
      t.string :type
      t.string :caption
      t.text :transcript
      t.integer :duration
      t.string :thumbnailUrl
    end
  end
end
