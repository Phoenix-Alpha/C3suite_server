require "shrine"

if Rails.env.development?
  require "shrine/storage/file_system"
  
  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"),
    store: Shrine::Storage::FileSystem.new("public", prefix: "uploads")
	}
else
	require "shrine/storage/s3"
	
	s3_options = {
	  bucket: 			 ENV['AWS_DIRECTORY'],
	  access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
	  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
	  region:            ENV['AWS_REGION'],
	}

	Shrine.storages = {
	  cache: Shrine::Storage::S3.new(prefix: "cache", **s3_options),
	  store: Shrine::Storage::S3.new(**s3_options),
	}
end	

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data # for retaining the cached file across form redisplays
Shrine.plugin :restore_cached_data # re-extract metadata when attaching a cached file
Shrine.plugin :validation_helpers