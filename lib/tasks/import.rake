namespace :import do
  require 'csv'

  desc "Import Quiz Data from CSV to a new Module, then add to Product"
  task :quizzes => [:environment] do
    file_path = "lib/seed/quizzes.csv"
    chapters = [Quiz.new(title: "New Quiz")]

    product = Product.find_or_create_by(title: 'EMT Tutor')
    content_id = product.contents.where(title: 'Quizzes').first.id if product.present?

    CSV.foreach(file_path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
      indx = row['chapter'].to_i

      if chapters.present?
        # create a Quiz object for each chapter
        if chapters.count < indx
          quiz = Quiz.new
          quiz.title = "Chapter #{indx - 1}"
          quiz.parent_id = content_id || Modulee.first.id
          quiz.product = product
          quiz.time_limit = 60 * rand(1..10)
          quiz.q_type = "default"
          quiz.description = "One-liner description what the quiz is all about."

          chapters.push(quiz)
        end

        # create a Question object
        q = Question.new
        q.question = row['question']
        q.explanation = row['explanation']
        q.correct = row['rightanswer']
        q.distractor1 = row['wronganswer1']
        q.distractor2 = row['wronganswer2']
        q.distractor3 = row['wronganswer3']
        q.distractor4 = row['wronganswer4']

        chapters[indx - 1].questions.push(q)
      end

      Quiz.import chapters unless chapters.blank?
    end
  end

  desc "Import Flashcard Data from CSV to a new Module, then add to the Product"
  task :flashcards => [:environment] do
    file_path = "lib/seed/flashcards.csv"
    chapters = [Flashcard.new(title: "New Flashcard Deck")]

    product = Product.find_or_create_by(title: 'EMT Tutor')
    content_id = product.contents.where(title: 'Flashcards').first.id if product.present?

    CSV.foreach(file_path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
      indx = row['chapter'].to_i

      if chapters.present?
        # create a Flashcard object for each chapter
        if chapters.count < indx
          flashcard = Flashcard.new
          flashcard.title = "Chapter #{indx - 1}"
          flashcard.product = product
          flashcard.parent_id = content_id || Modulee.first.id
          flashcard.description = "One-liner description what the flashcard is all about."

          chapters.push(flashcard)
        end

        # create a Question object
        item = FlashcardItem.new
        item.front = row['question']
        item.back = row['answer']

        chapters[indx - 1].flashcard_items.push(item)
      end

      Flashcard.import chapters unless chapters.blank?
    end
  end

end