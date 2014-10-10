module BucketMaker
  # Class which holds all the Series based information
  #
  class Series
    attr_reader :name,
                :description,
                :created_after,
                :buckets

    SERIES_DESCRIPTION  = 'description'
    SERIES_USER_AFTER   = 'created_after'
    SERIES_BUCKETS      = 'buckets'

    # Initializer
    #
    # @param name [String] Name of the Series
    # @param options [Hash] Options for the Series like SERIES_DESCRIPTION, SERIES_USER_AFTER, SERIES_BUCKETS
    #
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

    # Iterator going through each bucket
    #
    def map_bucket
      @buckets.map do |bucket_name, bucket|
        yield bucket_name, bucket
      end if block_given?
    end

    # Get the Bucket object when given the bucket_name
    #
    # @param bucket_name [String] Name of the Bucket
    # @return [BucketMaker::Bucket] Bucket object
    #
    def bucket_with_name(bucket_name)
      @buckets[bucket_name.to_sym] if bucket_name
    end

    # Check if the Bucketable object conforms to the conditions
    #
    # @param bucketable [Object] an object which responds to :created_at
    # @return [Boolean] is it bucketable?
    #
    def is_bucketable?(bucketable)
      bucketable.created_at >= @created_after rescue false
    end

    # Check if the Series has the bucket
    #
    # @param bucket_name [String] Name of the Bucket
    # @return [Boolean] does the bucket exist?
    #
    def has_bucket?(bucket_name)
      @buckets[bucket_name.to_sym] != nil rescue false
    end

    # Check if the bucket has the group
    #
    # @param bucket_name [String] Name of the Bucket
    # @param group_name [String] Name of the Group
    # @return [Boolean] does the group exist inside the bucket?
    #
    def has_group_in_bucket?(bucket_name, group_name)
      has_bucket?(bucket_name) && @buckets[bucket_name.to_sym].has_group?(group_name) rescue false
    end
  end
end
