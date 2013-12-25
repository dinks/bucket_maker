require 'bucket_maker/version'
require 'bucket_maker/configuration'
require 'bucket_maker/models/redisable'
require 'bucket_maker/models/active_recordable'

module BucketMaker
  require 'bucket_maker/engine' if defined?(Rails)
end
