class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || "must be a valid URL") unless url_valid?(value)    
  end

  # a URL may be technically well-formed but may 
  # not actually be valid, so this checks for both.
  def url_valid?(url)
    url = source.parse(url) rescue false
    url.kind_of?(source::HTTP) || url.kind_of?(source::HTTPS)
  end 
end