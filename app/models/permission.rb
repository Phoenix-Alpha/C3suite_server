class Permission < ApplicationRecord
  belongs_to :user
  belongs_to :product
  belongs_to :role

  validates_presence_of :user, :product, :role, :contents
  validates :user, uniqueness: { scope: [:product], message: "can be associated to a single role only."}

  serialize :contents, Array
end
