class RenameSubModulesTable < ActiveRecord::Migration[5.1]
  def change
    rename_table :sub_modules, :submodules
  end
end
