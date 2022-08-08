class ChangeEncodingForFlashcardsTable < ActiveRecord::Migration[5.2]
  def change
    char_set = 'utf8mb4'
    collate = 'utf8mb4_polish_ci'
    
    execute("ALTER TABLE flashcards CONVERT TO CHARACTER SET #{char_set} COLLATE #{collate};")
  end
end
