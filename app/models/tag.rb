class Tag < ApplicationRecord
  validates :name, uniqueness: true

  def self.plucked
    all.pluck(:name, :id)
  end
end
