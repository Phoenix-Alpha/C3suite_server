class BuildTest < ApplicationRecord
  belongs_to :user
  belongs_to :content

  serialize :content_type_ids, Array
  serialize :chapter_ids, Array 
end
