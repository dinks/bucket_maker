module BucketMaker
  class Series
    attr_reader :name,
                :description,
                :created_after,
                :buckets

    SERIES_DESCRIPTION  = 'description'
    SERIES_USER_AFTER   = 'created_after'
    SERIES_BUCKETS      = 'buckets'

    def initialize(name, options={})
      @name = name.to_sym
      @description = options[SERIES_DESCRIPTION] || ''
      @created_after =  if options[SERIES_USER_AFTER]
                                DateTime.parse(options[SERIES_USER_AFTER])
                              else
                                DateTime.parse("1st Jan 1900")
                              end
      @buckets =  options[SERIES_BUCKETS].inject({}) do |result, (bucket_name, bucket_options)|
                    result[bucket_name.to_sym] = BucketMaker::Bucket.new(bucket_name, bucket_options)
                    result
                  end if options[SERIES_BUCKETS]
    end

    def each_bucket
      @buckets.each do |bucket_name, bucket|
        yield bucket_name, bucket
      end if block_given?
    end

    def bucket_with_name(bucket_name)
      @buckets[bucket_name.to_sym]
    end

    def is_bucketable?(bucketable)
      bucketable.created_at >= @created_after
    end

    def has_bucket?(bucket_name)
      @buckets[bucket_name.to_sym] != nil
    end

    def has_group_in_bucket?(bucket_name, group_name)
      has_bucket?(bucket_name) && @buckets[bucket_name.to_sym].has_group?(group_name)
    end
  end
end
