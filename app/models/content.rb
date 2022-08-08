require 'csv'
class Content < ApplicationRecord
  include RankedModel
  include Rails.application.routes.url_helpers
  ranks :row_order, class_name: 'Content'

  actable
  has_ancestry

  validates :title, presence: true

  belongs_to :product

  has_many :content_assets, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :incorrect_questions, dependent: :destroy

  has_many :build_tests, dependent: :destroy
  has_many :viewed_contents, dependent: :destroy
  has_many :users, through: :viewed_content

  def user_bookmarks user
    bookmarks.where(user: user)
  end

  def image(kind)
    search = AssetKind.kinds(kind)
    source = nil
    search.each do |s|
      item = self.content_assets.find_by(kind: s)
      source = item.source_url if item.present?
      break unless source.nil?
    end
    if Rails.env.production?
      return  source.nil? ? root_url(host: '23.20.37.229')+'/images/placeholder.png' : source
    else
      return source.nil? ? '/images/placeholder.png' : source
    end
  end


  def printable_type
    return self.actable_type == 'Modulee' ? 'Module' : self.actable_type
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::Csv.new(file.path, packed: false, file_warning: :ignore)
    when ".xls" then Roo::Excel.new(file.path, packed: false, file_warning: :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, packed: false, file_warning: :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
end
