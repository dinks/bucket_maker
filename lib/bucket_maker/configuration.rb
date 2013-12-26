require 'forwardable'
require 'active_support/core_ext'
require 'bucket_maker/series_maker'

module BucketMaker
  # Configuration Holder for the BucketMaker
  #
  class Configuration
    attr_accessor :redis_options,
                  :path_prefix,
                  :buckets_config_file,
                  :lazy_load,
                  :redis_expiration_time

    attr_reader   :buckets_configuration,
                  :connection

    # Initializer
    # Sets up the default variable values
    #
    def initialize
      # For Redis
      @redis_options = {
        host:    'localhost',
        port:    6379,
        db:      1
      }
      @redis_expiration_time = 12.months

      # For paths
      # If nil, the routes wont be loaded
      @path_prefix = '2bOrNot2B/'

      # Configuration for the buckets
      #
      @buckets_config_file = nil
      @buckets_configuration = nil

      # Lazy Load is used to group only if in_bucket? is called
      # if false, then the group is done at creation time of the objec as well
      #
      @lazy_load = true
    end

    # Reconfigure the Configuration
    #
    def reconfigure!
      if @buckets_config_file
        @buckets_configuration = BucketMaker::SeriesMaker.instance
        @buckets_configuration.make!(@buckets_config_file)
      end
    end

    # Check if the configuration is done
    #
    # @return [Boolean]
    def configured?
      @buckets_configuration && @buckets_configuration.configured?
    end

    # Check if its ok to load routes
    #
    # @return [Boolean]
    #
    def load_routes?
      @path_prefix != nil
    end

  end

  class << self
    # Forward some of the calls to the configuration object
    #
    extend Forwardable

    attr_accessor :configuration

    def_delegators :@configuration, :configured?, :reconfigure!, :buckets_configuration, :load_routes?
  end

  # Configure after yielding to the block
  #
  def self.configure
    if block_given?
      self.configuration ||= Configuration.new
      yield self.configuration
      self.configuration.reconfigure!
    end
  end

end
