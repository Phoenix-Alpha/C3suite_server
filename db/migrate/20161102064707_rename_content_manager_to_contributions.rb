class RenameContentManagerToContributions < ActiveRecord::Migration[5.1]
  def change
    rename_table :content_managers, :contributions
  end
end
