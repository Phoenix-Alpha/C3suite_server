class BundleAsset < ApplicationRecord
    include AttachmentUploader[:source]
    belongs_to :bundle
  
    validates :kind, presence: true
  
    def my_kind
      ak = AssetKind.find(self.kind.to_i) if self.kind.present? && self.kind.to_i > 0
      ak.kind.capitalize unless ak.nil?
    end
  
    def self.active
      where(active: true)
    end
  
end
