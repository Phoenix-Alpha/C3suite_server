class ChangeContentTypeIdToBeTextInViewedcontents < ActiveRecord::Migration[5.1]
  def change
    change_column :viewed_contents, :content_type_id, :text
  end
end
