class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # Admin abilities
    if user.is_admin?
      can :manage, :all
      can :manage, Delayed::Job

    # Product Manager abilities
    elsif user.is_product_manager?
      can :read, User
      can :manage, Tag
      can :manage, [Product] do |p|
        p.users.pluck(:id).include? (user.id)
      end
      can [:read, :update], ProductAsset do |p|
        p.users.pluck(:id).include? (user.id)
      end
      can :manage, Modulee
      common_abilities(user, [:manage])
    # -------------------------------------------

    # Content Contributor abilities
    elsif user.is_content_contributor?
      can :manage, Tag
      common_abilities(user, [:read, :update])
    # -------------------------------------------

    # Content Manager abilities
    # TODO: Need to completely remove this after confirmation
    # elsif user.is_content_manager?
    #   common_abilities(user, [:read, :update])
    # -------------------------------------------

    # Instructor Abilities
    elsif user.is_instructor?
      can [:read], Product do |p|
        p.users.pluck(:id).include? user.id
      end
      common_abilities(user, [:read, :update])
    elsif user.is_customer?
      can :read, Bookmark
      can :read, Content
    end

  end

  def common_abilities(user, auth)
    can [:read], Product
    can auth, Content do |c|
      content_ids = user.permissions.collect { |p| p.contents }.flatten
      content_ids.include? ("#{c.id}")
    end
    can auth, Modulee do |m|
      is_managing_contents(user, m)
    end
    can auth, Submodule do |sm|
      is_managing_contents(user, sm)
    end
    can auth, Flashcard do |f|
      is_managing_contents(user, f)
    end
    can auth, Quiz do |q|
      is_managing_contents(user, q)
    end
    can auth, Media do |m|
      is_managing_contents(user, m)
    end
    can auth, Html do |h|
      is_managing_contents(user, h)
    end
  end

  def is_managing_contents(user, c_type)
    if user.is_product_manager?
      content_ids = user.permissions.collect { |p| p.product.contents.ids }.flatten
      # content_ids will have all content_ids that comes under each product
      content_ids.include? c_type.acting_as.id
    else
      content_ids = user.permissions.collect { |p| p.contents }.flatten
      # Allow access to all the children too
      content_ids = content_ids.reject(&:empty?)  #permitted contents_ids have type string 
      contents = content_ids.collect {|cid| Content.find(cid).subtree_ids }.flatten.uniq
      contents.include? c_type.acting_as.id
    end
    
  end
end
