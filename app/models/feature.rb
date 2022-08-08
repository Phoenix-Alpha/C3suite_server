class Feature < ApplicationRecord
  def self.enabled(name, user = nil)
    return false if name.nil?
    feature = self.where(:name => name).first_or_create!
    if user.nil?
      return feature.state == 'active'
    else
      percent = feature.percentage ||= 0
      if feature.state == 'active'
        return ((user.id % 100)*100 <= percent) | user.tester?
      end
      return Rails.env.test? | user.is_admin?
    end
  end

  def activate
    percent = self.percentage ||= 0
    self.update(:state => 'active', :percentage => percent)
  end

  def deactivate
    self.update(:state => 'deactivated', :percentage => 0)
  end

end
