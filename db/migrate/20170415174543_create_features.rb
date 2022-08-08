class CreateFeatures < ActiveRecord::Migration[5.1]
  def change
    create_table :features do |t|
      t.string :name
      t.string :state
      t.string :roles
      t.integer :percentage

      t.timestamps
    end
  end
end
