class ViewedContent < ApplicationRecord
  belongs_to :content
  belongs_to :user
  
  has_ancestry
  serialize :content_type_id, Hash
end
