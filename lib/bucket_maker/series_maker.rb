require 'singleton'
require 'yaml'
require 'active_support/inflector'
require 'bucket_maker/series'
require 'bucket_maker/bucket'

module BucketMaker
  # Singleton which holds all information regarding the series, buckets and groups
  #
  class SeriesMaker
    include Singleton

    attr_accessor :series

    attr_reader :configuration

    BUCKET_ROOT = 'series'

    # Set the class variables with configuration details
    #
    # @param config [String] Path of the config file WRT the rails app
    #
    def make!(config)
      @series = []

      absolute_config_path = Rails.root + config

      if File.exists?(absolute_config_path)
        @configuration = ::YAML.load_file(absolute_config_path)

        @series = @configuration[BUCKET_ROOT].inject({}) do |result, (series_name, series_options)|
                    result[series_name.to_sym] = BucketMaker::Series.new(series_name, series_options)
                    result
                  end if @configuration && @configuration[BUCKET_ROOT]
      end
    end

    # Check if the SeriesMaker is configured
    #
    # @return [Boolean] Signifies if the Object is configured
    #
    def configured?
      @configuration != nil
    end

    # Iterator for each series to be run on a Bucketable instance
    # Expects a block parameter to be passed
    #
    def for_each_series_with_bucketable
      @series.map do |series_name, series|
        series.each_bucket do |bucket_name, bucket|
          yield self, series_name, bucket_name
        end
      end.inject(true) {|result, value| result && value } if block_given?
    end

    # Get the Series object when given the series_name
    #
    # @param series_name [String] Series Name to search
    # @return [BucketMaker::Series]
    #
    def series_with_name(series_name)
      @series[series_name.to_sym] if series_name
    end

    # Check if the series exist
    #
    # @param series_name [String] Series Name to search
    # @return [Boolean] is it there?
    #
    def has_series?(series_name)
      @series[series_name.to_sym] != nil rescue false
    end

    # Check if the bucket exist in the series
    #
    # @param series_name [String] Series Name to search
    # @param bucket_name [String] Bucket Name to search
    # @return [Boolean] is it there?
    #
    def has_bucket_in_series?(series_name, bucket_name)
      has_series?(series_name) && series_with_name(series_name).has_bucket?(bucket_name) rescue false
    end

    # Check if the group exists in the bucket in the series
    #
    # @param series_name [String] Series Name to search
    # @param bucket_name [String] Bucket Name to search
    # @param group_name [String] Group Name to search
    # @return [Boolean] is it there?
    #
    def has_group_in_bucket_in_series?(series_name, bucket_name, group_name)
      has_bucket_in_series?(series_name, bucket_name) &&
      series_with_name(series_name).bucket_with_name(bucket_name).has_group?(group_name) rescue false
    end

    # Get the key for the combination
    #
    # @param bucketable [Object] any object which responds to :id
    # @param series_name [String] Series Name
    # @param bucket_name [String] Bucket Name
    # @return [String] The key for future use
    #
    def key_for_series(bucketable, series_name, bucket_name)
      "bucket_maker:#{bucketable.class.to_s.underscore}_#{bucketable.id}:#{series_name.to_s}:#{bucket_name.to_s}" if bucketable && bucketable.id rescue nil
    end

    # Get a random group for the bucket in a series
    #
    # @param series_name [String] Series Name
    # @param bucket_name [String] Bucket Name
    # @return [String] Random Group Name according to the distribution
    #
    def bucketize(series_name, bucket_name)
      series_with_name(series_name).bucket_with_name(bucket_name).random_group rescue nil
    end

    # Check if a Bucketable Object conform to the pre-conditions
    #
    # @param bucketable [Object] any object which has methods :has_attribute?, :created_at and :id
    # @param series_name [String] Series Name
    # @param bucket_name [String] Bucket Name
    # @param group_name [String] Group Name
    # @return [Boolean] is it bucketable?
    #
    def bucketable?(bucketable, series_name, bucket_name, group_name)
      if  bucketable.has_attribute?(:created_at) &&
          has_group_in_bucket_in_series?(series_name, bucket_name, group_name)

        series_with_name(series_name).bucket_with_name(bucket_name).is_bucketable?(bucketable) ||
        series_with_name(series_name).is_bucketable?(bucketable) rescue false

      else
        false
      end
    end
  end
end
