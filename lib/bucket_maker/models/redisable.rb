require 'active_support/concern'
require 'bucket_maker/models/bucketable'

module BucketMaker
  module Models
    module Redisable
      extend ActiveSupport::Concern

      included do
        if BucketMaker.configured?
          extend ClassMethods

          send(:include, InstanceMethods)

          after_create :bucketize unless BucketMaker.configuration.lazy_load
          restart_for_disconnect_in_passenger
        end
      end

      module InstanceMethods
        include BucketMaker::Models::Bucketable

        def group_for_key(series_key)
          self.class.redis.get(series_key)
        end

        def set_group_for_key(series_key, group_name)
          self.class.redis.setex(series_key, BucketMaker.configuration.redis_expiration_time, group_name)
        end
      end

      module ClassMethods

        def redis
          @redis || connect_redis
        end

        def connect_redis
          disconnect_redis
          @redis ||= Redis.new(BucketMaker.configuration.redis_options)
        end

        def disconnect_redis
          @redis.disconnect if @redis
        ensure
          @redis = nil
        end

        def restart_for_disconnect_in_passenger
          PhusionPassenger.on_event(:starting_worker_process) do |forked|
            disconnect_redis if forked # We're in smart spawning mode
          end if defined?(PhusionPassenger)
        end

      end

    end
  end
end
