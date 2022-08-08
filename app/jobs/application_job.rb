require 'rubygems'
require 'zip'

class ApplicationJob < ActiveJob::Base

  QuizUploadJob = Struct.new(:csv, :product, :content_id) do
    def perform
      chapters = [Quiz.new(title: "Chapter 0")]
      questions = []
      hsh = []

      CSV.parse(csv, headers: true, encoding:'iso-8859-1:utf-8') do |row|
        indx = row['chapter'].to_i || row['Section/Chapter'].to_i

        if chapters.present?
          # create a Quiz object for each chapter
          if chapters.count < indx
            quiz = Quiz.new
            quiz.title = "Chapter #{indx - 1}"
            quiz.parent_id = content_id
            quiz.product = product
            quiz.time_limit = 60 * rand(1..10)
            quiz.q_type = "default"
            quiz.description = "One-liner description what the quiz is all about."

            chapters << quiz
            hsh[chapters[indx - 1].title] = []
          end

          # create a Question object
          q = {
            question: row['question'] || row['Question'],
            explanation: row['explanation'] || row['Explanation'],
            correct: row['rightanswer'] || row['Correct Answer'],
            distractor1: row['wronganswer1'] || row[4],
            distractor2: row['wronganswer2'] || row[5],
            distractor3: row['wronganswer3'] || row[6],
            distractor4: row['wronganswer4'] || row[7]
          }

          hsh["#{chapters[indx - 1].title}"] << q
        end
      end

      puts hsh.inspect
    end

    def max_attempts
      1
    end
  end

  FlashcardUploadJob = Struct.new(:csv, :product, :content_id) do
    def perform
      chapters = [Flashcard.new(title: "New Flashcard Deck")]

      CSV.parse(csv, headers: true, encoding:'iso-8859-1:utf-8') do |row|
        indx = row['chapter'].to_i

        if chapters.present?
          # create a Flashcard object for each chapter
          if chapters.count < indx
            flashcard = Flashcard.new
            flashcard.title = "Chapter #{indx - 1}"
            flashcard.product = product
            flashcard.parent_id = content_id
            flashcard.description = "One-liner description what the flashcard is all about."

            chapters.push(flashcard)
          end

          # create a FlashcardItem object
          item = FlashcardItem.new
          item.front = row['question']
          item.back = row['answer']

          chapters[indx - 1].flashcard_items.push(item)
        end
      end

      Flashcard.import chapters unless chapters.blank?
    end

    def max_attempts
      1
    end
  end

  HtmlUploadJob = Struct.new(:file, :product, :content_id) do
    def perform
      htmls = []

      Zip::File.open(file) do |zip_file|
        zip_file.glob('*.html').each do |entry|
          html = Html.new

          html.title = entry.name.split('.html').first
          html.description = entry.name.split('.html').first
          html.html_source = entry.get_input_stream.read
          html.content_id = content_id

          htmls << html
        end
      end

      Html.import htmls unless htmls.blank?
    end

    def max_attempts
      1
    end
  end

end
