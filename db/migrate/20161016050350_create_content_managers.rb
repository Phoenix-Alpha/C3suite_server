class CreateContentManagers < ActiveRecord::Migration[5.1]
  def change
    create_table :content_managers do |t|
      t.references :user, foreign_key: true
      t.references :content, foreign_key: true
    end
  end
end
