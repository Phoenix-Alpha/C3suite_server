require 'rubygems'
require 'zip'
require 'roo'

class Product < ApplicationRecord
  include AttachmentUploader[:background]
  include Rails.application.routes.url_helpers
  extend FriendlyId
  friendly_id :title, use: :slugged
  VISIBILITY_ALL = "All"
  VISIBILITY_REGISTERED_USERS = "Registered Users"
  VISIBILITY_PRIVILEGED_USERS = "Privileged Users"

  def should_generate_new_friendly_id?
    title_changed?
  end

  has_paper_trail

  validates :title, presence: true, uniqueness: {case_sensitive: true}
  validates :price, presence: true

  has_many :permissions, dependent: :destroy
  has_many :users, through: :permissions
  accepts_nested_attributes_for :permissions, reject_if: :all_blank, allow_destroy: true

  serialize :tags, Array
  serialize :app, Hash
  serialize :stripe, Hash
  serialize :configurations, Hash

  has_many :user_subscriptions, dependent: :destroy
  has_many :subscribed_users, through: :user_subscriptions, class_name: 'User', foreign_key: :user_id, source: :user

  has_many :contents, dependent: :destroy
  accepts_nested_attributes_for :contents, reject_if: :all_blank, allow_destroy: true

  has_many :product_assets

  def self.visibility_options
    [VISIBILITY_ALL, VISIBILITY_REGISTERED_USERS, VISIBILITY_PRIVILEGED_USERS].freeze
  end

  def image(kind)
    search = AssetKind.kinds(kind)
    
    source = nil
    search.each do |s|
      item = self.product_assets.find_by(kind: s)
      source = item.source_url if item.present?
      break unless source.nil?
    end
    if Rails.env.production?
      return  source.nil? ? root_url(host: '23.20.37.229')+'/images/placeholder.png' : source
    else
      return source.nil? ? '/images/placeholder.png' : source
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::CSV.new(file.path, packed: false, file_warning: :ignore, csv_options: { encoding: Encoding::ISO_8859_1 })
    when ".xls" then Roo::Excel.new(file.path, packed: false, file_warning: :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, packed: false, file_warning: :ignore)
    else raise ExceptionHandler::InvalidInputFileType, "Invalid Input File: Only .xls, .xlsx, .csv are accepted"
    end
  end

  def import_quizzes(file, content_id)
    csv = Product.open_spreadsheet(file).to_csv

    chapters = []
    hsh = Hash.new

    CSV.parse(csv, headers: true, encoding:'iso-8859-1:utf-8') do |row|
      title = row['Chapter'] || row[0]

      # create a Quiz object for each chapter
      if hsh[title].blank?
        quiz = Quiz.new
        quiz.title = title
        quiz.parent_id = content_id
        quiz.product = self
        quiz.q_type = "default"
        quiz.description = "One-liner description what the quiz is all about."

        chapters << quiz
      end

      question = {
        question: row['Question'] || row[1],
        hint: row['Hint'] || row[2],
        explanation: row['Explanation'] || row[3],
        correct: row['Correct Answer'] || row[4],
        distractor1: row['Distractor 1'] || row[5],
        distractor2: row['Distractor 2'] || row[6],
        distractor3: row['Distractor 3'] || row[7],
        distractor4: row['Distractor 4'] || row[8],
        distractor5: row['Distractor 5'] || row[9],
        distractor6: row['Distractor 6'] || row[10],
        distractor7: row['Distractor 7'] || row[11],
        distractor8: row['Distractor 8'] || row[12],
        distractor9: row['Distractor 9'] || row[13],
        category: row['category'] || row[14] || ''
      }

      hsh[title] ||= []
      hsh[title] << question
    end

    chapters ||= []
    chapters.each do |chp|
      chp.save_with_nested_attributes(hsh[chp.title])
    end
  end

  def import_flashcards(file, content_id)
    begin
    csv = Product.open_spreadsheet(file).to_csv

    chapters = []
    hsh = Hash.new

    CSV.parse(csv, headers: true, encoding:'iso-8859-1:utf-8') do |row|
      title = row['Chapter'] || row[0]

      # create a Flashcard object for each chapter
      if hsh[title].blank?
        flashcard = Flashcard.new
        flashcard.title = title
        flashcard.product = self
        flashcard.parent_id = content_id
        flashcard.description = "One-liner description what the flashcard is all about."

        chapters << flashcard
      end

      # create a FlashcardItem object
      flashcard_item = {
        front: row['Question'] || row[1],
        back: row['Answer'] || row[2]
      }

      hsh[title] ||= []
      hsh[title] << flashcard_item
    end

    chapters ||= []

    chapters.each do |chp|
      chp.save_with_nested_attributes(hsh[chp.title])
    end

    rescue ActiveRecord::StatementInvalid => e
      render( inline: "Your uploaded file has invalid format." )
      return
    end
  end

  def import_htmls(files, content_id)
    if files.kind_of?(Array) && files.length > 0
      htmls = []

      files.each do |file|
        if file.content_type == 'application/zip'
          tempfile = file.tempfile
          Zip::File.open(tempfile) do |zip_file|
            zip_file.glob('*.html').each do |entry|
              html = Html.new

              html.title = entry.name.split('.html').first
              html.description = entry.name.split('.html').first
              html.html_source = entry.get_input_stream.read
              html.product = self
              html.parent_id = content_id

              html.save!
            end
          end
        elsif file.content_type == 'text/html'
          html = Html.new

          html.title = file.original_filename
          html.description = file.original_filename
          html.html_source = file.read
          html.product = self
          html.parent_id = content_id

          html.save!
        end
      end
    end

    # job = ApplicationJob::HtmlUploadJob.new file, self, content_id
    # Delayed::Job.enqueue job
  end
end
