class RenameThumbnailUrlWithSnakeCase < ActiveRecord::Migration[5.1]
  def change
    rename_column :media, :thumbnailUrl, :thumbnail_url
  end
end
