# Configure the BucketMaker
BucketMaker.configure do |config|
  # Path Prefix
  # All the Series, Buckets and Groups can be viewed/edited via a special URI
  # The path prefix is used to prefix these routes
  #
  # Default value - '2bOrNot2B/'
  # config.path_prefix = '2bOrNot2B/'
  #
  # Redis Options
  # Set the Redis options which can be host, port and db
  # This takes effect when in module included
  # in the ActiveModel is BucketMaker::Models::Redisable
  #
  # Default value - { host: 'localhost', port: 6379, db: 1 }
  # config.redis_options = {
  #   host:    'localhost',
  #   port:    6379,
  #   db:      1
  #   }
  #
  # Buckets Config File
  # The configuration file for adding/removing Series, Buckets and Groups
  #
  config.buckets_config_file = 'config/buckets.yml'
  #
  # Lazy Load
  # If false then Bucketize the object on creation
  # If true then the Bucketization happens on the first call of in_bucket?
  #
  # Default value - true
  # config.lazy_load = true
  #
  # Redis Expiration Time
  # The redis expiration time if the configuration is for Redis
  #
  # Default value - 12.months
  # config.redis_expiration_time = 12.months
  #
end

