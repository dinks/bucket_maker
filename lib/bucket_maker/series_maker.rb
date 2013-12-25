require 'active_support/inflector'
require 'bucket_maker/series'
require 'bucket_maker/bucket'

module BucketMaker
  class SeriesMaker
    include Singleton

    attr_accessor :series

    attr_reader :configuration

    BUCKET_ROOT = 'series'

    def make!(config)
      @series = []

      absolute_config_path = Rails.root + config

      if File.exists?(absolute_config_path)
        @configuration = YAML.load_file(absolute_config_path)

        @series = @configuration[BUCKET_ROOT].inject({}) do |result, (series_name, series_options)|
                    result[series_name.to_sym] = BucketMaker::Series.new(series_name, series_options)
                    result
                  end if @configuration && @configuration[BUCKET_ROOT]
      end
    end

    def configured?
      @configuration != nil
    end

    def for_each_series_with_bucketable
      @series.collect do |series_name, series|
        series.each_bucket do |bucket_name, bucket|
          yield self, series_name, bucket_name
        end
      end.inject(true) {|result, value| result && value } if block_given?
    end

    def series_with_name(series_name)
      @series[series_name.to_sym]
    end

    def has_series?(series_name)
      @series[series_name.to_sym] != nil
    end

    def has_bucket_in_series?(series_name, bucket_name)
      has_series?(series_name) && series_with_name(series_name).has_bucket?(bucket_name)
    end

    def has_group_in_bucket_in_series?(series_name, bucket_name, group_name)
      has_bucket_in_series?(series_name, bucket_name) &&
      series_with_name(series_name).bucket_with_name(bucket_name).has_group?(group_name)
    end

    def key_for_series(bucketable, series_name, bucket_name)
      "bucket_maker:#{bucketable.class.to_s.underscore}_#{bucketable.id}:#{series_name.to_s}:#{bucket_name.to_s}" if bucketable && bucketable.id
    end

    def bucketize(series_name, bucket_name)
      series_with_name(series_name).bucket_with_name(bucket_name).random_group
    end

    def bucketable?(bucketable, series_name, bucket_name, group_name)
      if  bucketable.has_attribute?(:created_at) &&
          has_group_in_bucket_in_series?(series_name, bucket_name, group_name)

        series_with_name(series_name).bucket_with_name(bucket_name).is_bucketable?(bucketable) ||
        series_with_name(series_name).is_bucketable?(bucketable)

      else
        false
      end
    end
  end
end
