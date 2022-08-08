class ActiveRecord::Reflection::AssociationReflection
  def build_association(*options)
    if options.first.is_a?(Hash) and options.first[:actable_type].presence
      options.first[:actable_type].to_s.constantize.new(*options)
    else
      klass.new(*options)
    end
  end
end
