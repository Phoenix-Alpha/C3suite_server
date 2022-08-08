class RemoveColumnDescriptionFromHtmls < ActiveRecord::Migration[5.1]
  def change
    remove_column :htmls, :description, :string
  end
end
