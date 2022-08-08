module MediaHelper
  def media_source media
    return "" unless media.source.present?
    media.source_url

  end
end