require 'active_support/concern'
require 'bucket_maker/models/bucketable'

module BucketMaker
  module Models
    module ActiveRecordable
      extend ActiveSupport::Concern

      included do
        if BucketMaker.configured?
          send(:include, InstanceMethods)

          has_many :buckets, as: :bucketable

          after_create :bucketize unless BucketMaker.configuration.lazy_load
        end
      end

      module InstanceMethods
        include BucketMaker::Models::Bucketable

        def group_for_key(series_key)
          if b = buckets.select('group_name').where(series_key: series_key).take
            b.group_name
          end
        end

        def set_group_for_key(series_key, group_name)
          buckets.where(series_key: series_key, group_name: group_name).first_or_create
          true
        end
      end
    end
  end
end
