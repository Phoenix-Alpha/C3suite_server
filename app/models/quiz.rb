class Quiz < ApplicationRecord
  acts_as :content

  validate :minimum_time_for_quiz_attempt
  validates_numericality_of :passing_percentage, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100, :only_integer => true, allow_nil: true
  has_many :questions, dependent: :destroy
  accepts_nested_attributes_for :questions, reject_if: :all_blank, allow_destroy: true

  has_many :quiz_attempts
  has_many :users, through: :quiz_attempt

  def minimum_time_for_quiz_attempt
    errors.add(:time_limit, "can't be less than 60 seconds (or 1 minute).") if time_limit != nil && time_limit < 60
  end

  def import(file)
    csv = Product.open_spreadsheet(file).to_csv

    encoding_options = {
        :invalid           => :replace,  # Replace invalid byte sequences
        :undef             => :replace,  # Replace anything not defined in ASCII
        :replace           => '',        # Use a blank for those replacements
        :universal_newline => true       # Always break lines with \n
    }

    self.questions.destroy_all
    CSV.parse(csv, headers: true, encoding:'iso-8859-1:utf-8') do |row|

      question_hash = row.to_hash
      clean_hash = {}
      question_hash.each do |key, value|
        key = key.downcase
        key = key.encode(Encoding.find('ASCII'), encoding_options) if key.present?
        value = value.encode(Encoding.find('ASCII'), encoding_options) if value.present?
        clean_hash[key] = value
      end
      self.questions.create!(clean_hash)
    end # end CSV.foreach
  end

  def save_with_nested_attributes(questions_attributes)
    questions_objects = []

    transaction do
      save!
      questions_attributes.each do |question_attributes|
        question = Question.new(question_attributes)
        question.quiz_id = self.id
        questions_objects << question
      end

      Question.import questions_objects
    end
  end

  def items
    questions
  end
end
