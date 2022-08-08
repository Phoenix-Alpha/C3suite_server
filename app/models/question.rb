class Question < ApplicationRecord
  belongs_to :quiz
  
  def self.to_csv
    attributes = %w{question explanation hint correct distractor1 distractor2 distractor3 distractor4 distractor5 distractor6 distractor7 distractor8 distractor9}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |question|
        csv << attributes.map{ |attr| question.send(attr) }
      end
    end

  end

  def content
    quiz.content
  end
end
