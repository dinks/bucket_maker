module BucketMaker
  class Bucket
    attr_accessor :name,
                  :summary,
                  :created_after,
                  :distributions

    attr_reader   :distributions_percent

    BUCKET_DESCRIPTION  = 'description'
    BUCKET_USER_AFTER   = 'created_after'
    BUCKET_DISTRIBUTION = 'distributions'

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

    def random_group
      # Is set after first randomization
      unless @distributions_percent
        @denominator = @distributions.inject(0) do |result, (_, dist_value)|
                        result + dist_value
                      end
        @distributions_percent =  @distributions.inject({}) do |result, (dist_name, dist_value)|
                                    result[dist_name.to_sym] = (dist_value * 100.0)/@denominator
                                    result
                                  end

        @distributions_percent.inject(0) do |starter, (dist_name, percent_value)|
          ender = starter + percent_value
          @distributions_percent[dist_name.to_sym] = (starter .. ender)
          ender
        end
      end

      randomized = rand(@denominator * 100)
      @distributions_percent.find do |_, percent_range|
        percent_range.include?(randomized)
      end.first
    end

    def is_bucketable?(bucketable)
      bucketable.created_at >= @created_after
    end

    def has_group?(group_name)
      @distributions[group_name.to_sym] != nil
    end
  end
end
