class AddColumnSectionTitleToModulee < ActiveRecord::Migration[5.1]
  def change
    add_column :modulees, :section_title, :string
  end
end
