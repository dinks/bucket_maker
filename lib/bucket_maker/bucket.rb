module BucketMaker
  # Class which holds all the Bucket information
  #
  class Bucket
    attr_accessor :name,
                  :summary,
                  :created_after,
                  :distributions

    attr_reader   :distributions_percent

    BUCKET_DESCRIPTION  = 'description'
    BUCKET_USER_AFTER   = 'created_after'
    BUCKET_DISTRIBUTION = 'distributions'

    # Initializer
    #
    # @param name [string] Name of the Bucket
    # @param options [Hash] Options for the Bucket like BUCKET_DESCRIPTION, BUCKET_USER_AFTER, BUCKET_DISTRIBUTION
    #
    def initialize(name, options={})
      @name = name.to_sym
      @summary = options[BUCKET_DESCRIPTION]

      @created_after =  if options[BUCKET_USER_AFTER]
                                DateTime.parse(options[BUCKET_USER_AFTER])
                              else
                                DateTime.parse("1st Jan 1900")
                              end

      @distributions_percent = nil
      @denominator = 1
      @distributions = options[BUCKET_DISTRIBUTION].inject({}) do |result, (dist_name, dist_options)|
                        result[dist_name.to_sym] = dist_options
                        result
                      end if options[BUCKET_DISTRIBUTION]
    end

    # Randomize and get the group for this bucket
    #
    # @return [String] Group Name after randomization
    #
    def random_group
      # Is set after first randomization
      unless @distributions_percent
        # Get the total value of the distributions
        #
        @denominator = @distributions.inject(0) do |result, (_, dist_value)|
                        result + dist_value
                      end
        # Populate the variable with Distribution Percentages
        #
        @distributions_percent =  @distributions.inject({}) do |result, (dist_name, dist_value)|
                                    result[dist_name.to_sym] = (dist_value * 100.0)/@denominator
                                    result
                                  end
        # Change the Distribution Percentages with Ranges for easy checks
        #
        @distributions_percent.inject(0) do |starter, (dist_name, percent_value)|
          ender = starter + percent_value
          @distributions_percent[dist_name.to_sym] = (starter .. ender)
          ender
        end
      end

      # Randomize within the 0..max_range
      #
      randomized = rand(@denominator * 100)
      # Find where the randomized number falls in the calculated range
      #
      @distributions_percent.detect do |_, percent_range|
        percent_range.include?(randomized)
      end.first
    end

    # Check if the Bucketable conforms to the pre-conditions
    #
    # @param bucketable [Object] an object which responds to :created_at
    # @return [Boolean] is it bucketable?
    #
    def is_bucketable?(bucketable)
      bucketable.created_at >= @created_after rescue false
    end

    # Check if there is a group in this bucket
    #
    # @param group_name [String] Name of the group
    # @return [Boolean] does the group exist?
    #
    def has_group?(group_name)
      @distributions[group_name.to_sym] != nil if group_name
    end
  end
end
