class CreateModulees < ActiveRecord::Migration[5.1]
  def change
    create_table :modulees do |t|
      t.string :name
    end
  end
end
