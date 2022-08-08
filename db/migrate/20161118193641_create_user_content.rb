class CreateUserContent < ActiveRecord::Migration[5.1]
  def change
    create_table :user_contents do |t|
      t.belongs_to :contents, index: true
      t.belongs_to :user, index: true
      t.integer :starttime
      t.integer :stoptime
      end
  end
end
