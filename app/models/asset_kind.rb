class AssetKind < ApplicationRecord

  def self.kinds(kind)
    item = self.find_or_create_by!(kind: kind)
    search = [item.id]
    alternates = item.alternates || ''
    alternates.split(/\s*,\s*/).each do |alt|
      alt_item = self.find_by(kind: alt)
      search += alt_item.id if alt_item.present?
    end
    search
  end
end
