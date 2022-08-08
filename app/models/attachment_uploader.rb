class AttachmentUploader < Shrine
  require 'mini_magick'
  require "streamio-ffmpeg"
      
  plugin :processing
  plugin :versions
  plugin :determine_mime_type
  plugin :cached_attachment_data
  plugin :remove_attachment
  plugin :delete_raw
  # plugin :delete_promoted

  Attacher.validate do
    validate_max_size 10.megabyte, message: "is too large (max size 10 MB)"  
    if record.class.name == "Media"
      validate_mime_type_inclusion ['image/jpg', 'image/jpeg', 'image/png', 'image/gif'], message: "file is not valid for selected 'Media Type',  Allowed types:['image/jpg', 'image/jpeg', 'image/png']" if record.local_type == "Image"
      validate_mime_type_inclusion ['audio/mp3', 'audio/mpeg'], message: "file is not valid for selected 'Media Type',  Allowed types:['audio/mp3', 'audio/mpeg']" if record.local_type == "Audio"
      validate_mime_type_inclusion ['video/mp4', 'video/webm', 'video/quicktime'], message: "file is not valid for selected #{record.local_type},  Allowed types are #{['video/mp4', 'video/webm', 'video/mov'].join(', ')}" if record.local_type == "Video"
    else
      validate_mime_type_inclusion ['image/jpg', 'image/jpeg', 'image/png', 'application/pdf']
    end
  end

  
  #process(:store) do |io, context|
  #  versions = {}
  #  io.download do |original|
  #    #if IMAGE_EXT_ALLOWED.include? io.mime_type
  #    #  versions = { original: io }
  #    #  versions[:small] = ImageProcessing::Vips.source(original).resize_to_limit!()
  #    if VIDEO_EXT_ALLOWED.include? io.mime_type
  #        versions = { original: io }
  #        file = FFMPEG::Movie.new(original.path)
  #        versions[:thumb] = file.screenshot('thumb.jpg',seek_time: (file.duration/2).round)
  #    end
  #  end
  #
  #  versions if versions.present?
  #  
  #end

  def generate_location(io, context)
    type  = context[:record].class.name.underscore if context[:record]
    name  = super # the default unique identifier

    [type, name].compact.join("/")
  end
end