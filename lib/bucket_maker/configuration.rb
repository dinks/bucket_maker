require 'forwardable'
require 'active_support/core_ext'
require 'bucket_maker/series_maker'

module BucketMaker
  class Configuration
    attr_accessor :redis_options,
                  :path_prefix,
                  :buckets_config_file,
                  :lazy_load,
                  :redis_expiration_time

    attr_reader   :buckets_configuration,
                  :connection

    def initialize
      @redis_options = {
        host:    'localhost',
        port:    6379,
        db:      1
      }

      @redis_expiration_time = 12.months

      @path_prefix = '2bOrNot2B/'

      @buckets_config_file = nil
      @buckets_configuration = nil

      @lazy_load = true
    end

    def reconfigure!
      if @buckets_config_file
        @buckets_configuration = BucketMaker::SeriesMaker.instance
        @buckets_configuration.make!(@buckets_config_file)
      end
    end

    def configured?
      @buckets_configuration && @buckets_configuration.configured?
    end

    def load_routes?
      @path_prefix != nil
    end

  end

  class << self
    extend Forwardable

    attr_accessor :configuration

    def_delegators :@configuration, :configured?, :reconfigure!, :buckets_configuration, :load_routes?
  end

  def self.configure
    if block_given?
      self.configuration ||= Configuration.new
      yield self.configuration
      self.configuration.reconfigure!
    end
  end

end
