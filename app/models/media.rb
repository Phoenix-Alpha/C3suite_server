class Media < ApplicationRecord
  include AttachmentUploader[:source] 

  acts_as :content

  MEDIA_TYPES = ['Image', 'Audio', 'Video']
  
  validates_presence_of :caption, length: { minimum: 5 }
  
end
