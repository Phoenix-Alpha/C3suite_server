class ChangeColumnSideToSideDataInFlashcardsForShrine < ActiveRecord::Migration[5.2]
  def change
  	rename_column :flashcard_items, :side, :side_data
  end
end
