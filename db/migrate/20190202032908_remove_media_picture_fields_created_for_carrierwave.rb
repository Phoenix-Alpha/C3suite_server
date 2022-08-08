class RemoveMediaPictureFieldsCreatedForCarrierwave < ActiveRecord::Migration[5.2]
  def change
    remove_column :media, :source
    remove_column :media, :source_tmp
    remove_column :media, :source_processing
  end
end
