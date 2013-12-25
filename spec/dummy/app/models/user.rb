require 'mock_redis'

class User < ActiveRecord::Base

  include BucketMaker::Models::Redisable

  def self.redis
    # We Mock the redis behaviour here
    @redis ||= MockRedis.new
  end

end
