class User < ApplicationRecord
  ADMIN = 'Admin'
  PRODUCT_MANAGER = 'Product Manager'
  CONTENT_CONTRIBUTOR = 'Content Contributor'
  INSTRUCTOR = 'Instructor'
  CUSTOMER = 'Customer'

  has_ancestry

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :permissions, dependent: :destroy
  has_many :products, through: :permissions

  has_many :bundle_subscriptions, dependent: :destroy
  has_many :subscribed_bundles, through: :bundle_subscriptions, class_name: 'Bundle', foreign_key: :bundle_id, source: :bundle

  has_many :user_subscriptions, dependent: :destroy
  has_many :subscribed_products, through: :user_subscriptions, class_name: 'Product', foreign_key: :product_id, source: :product

  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles

  has_many :bookmarks, dependent: :destroy

  has_many :viewed_contents, dependent: :destroy
  has_many :contents, through: :viewed_content

  has_many :quiz_attempts
  has_many :quizzes, through: :quiz_attempts

  # validates :username, presence: true, uniqueness: true

  before_create :set_default_role

  scope :product_managers, -> { joins(:roles).where('roles.name = ?', PRODUCT_MANAGER) }
  scope :admins, -> { joins(:roles).where('roles.name = ?', ADMIN) }
  scope :non_admins, -> { joins(:roles).where('roles.name != ?', ADMIN).uniq }
  scope :permitted_users, -> { joins(:roles).where('roles.name != ? and roles.name !=?', ADMIN, CUSTOMER).uniq }

  def self.all_except(user)
    where.not(id: user).collect { |u| u if u.roles.pluck(:name).exclude? 'Admin' }.compact
  end

  def has_role?(role)
    if role.instance_of? Array
      role = role.collect { |r| r.to_s.split('_').join(' ').titleize }
      (roles.pluck(:name) & role).empty?
    else
      role.to_s.to_i > 0 ? (roles.pluck(:id).include? role.to_i) : (roles.pluck(:name).include? role.to_s.split('_').join(' ').titleize)
    end
  end

  def is_admin?
    is_type?("Admin")
  end

  def is_product_manager?
    is_type?("Product Manager")
  end

  # TODO: Need to completely remove this after confirmation
  # def is_content_manager?
  #   is_type?("Content Manager")
  # end

  def is_content_contributor?
    is_type?("Content Contributor")
  end

  def is_instructor?
    is_type?("Instructor")
  end

  def is_customer?
    is_type?("Customer")
  end

  def privileged?
    self && self.roles.present? && !self.is_customer?
  end

  private

  def is_type? type
    self.roles.map(&:name).include?(type) ? true : false
  end

  def set_default_role
    self.roles = [Role.find_or_create_by(name: 'Customer')] if self.roles.blank?
  end

end
