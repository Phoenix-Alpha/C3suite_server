class AddSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :sessions do |t|
      t.text :session_id,  null: false, :length=>255
      t.longtext :data

      ## Rememberable
      t.datetime :created_at
      t.datetime :updated_at

    end
    add_index :sessions, :session_id,    unique: true, :length=>255
  end
end
