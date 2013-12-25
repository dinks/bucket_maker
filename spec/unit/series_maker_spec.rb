require 'spec_helper'

describe BucketMaker::SeriesMaker do
  let(:bucket_maker) { BucketMaker::SeriesMaker.instance }
  let(:user) { build(:user, id: 12345) }
  let(:existing_series) { 'test_series_one' }
  let(:existing_bucket) { 'actual_test_one' }
  let(:existing_group)  { 'group_two' }

  before do
    BucketMaker::Bucket.any_instance.stub(:random_group) { existing_group }
  end

  context 'for configuration' do
    it 'should have correct number of series' do
      bucket_maker.series.keys.length.should == 2 # Look at config/buckets.yml
    end

    it 'should have correct number of buckets' do
      bucket_maker.series_with_name(existing_series).buckets.keys.length.should == 2
    end

    it 'should have correct number of distribut' do
      bucket_maker.series_with_name(existing_series).bucket_with_name(existing_bucket).distributions.keys.length.should == 3
    end
  end

  context '#configured?' do
    it 'should be configured' do
      bucket_maker.configured?.should be_true
    end
  end

  context '#key_for_series' do
    it 'should return the correct key' do
      bucket_maker.key_for_series(user, 'series_one', 'bucket_one').should == 'bucket_maker:user_12345:series_one:bucket_one'
    end
  end

  context '#has_series?' do
    it 'should return true for an existing series' do
      bucket_maker.has_series?(existing_series).should be_true
    end

    it 'should return false for a non existing series' do
      bucket_maker.has_series?('non_existing_series').should be_false
    end
  end

  context '#series_with_name' do
    it 'should return a Series object' do
      bucket_maker.series_with_name(existing_series).should be_kind_of(BucketMaker::Series)
    end
  end

  context '#has_bucket_in_series?' do
    it 'should return true for an existing bucket' do
      bucket_maker.has_bucket_in_series?(existing_series, existing_bucket).should be_true
    end

    it 'should return false for a non existing bucket' do
      bucket_maker.has_bucket_in_series?('non_existing_series', existing_bucket).should be_false
    end
  end

  context '#has_group_in_bucket_in_series?' do
    it 'should return true for an existing group' do
      bucket_maker.has_group_in_bucket_in_series?(existing_series, existing_bucket, existing_group).should be_true
    end

    it 'should return false for a non existing group' do
      bucket_maker.has_group_in_bucket_in_series?('non_existing_series', existing_bucket, existing_group).should be_false
    end
  end

  context '#bucketize' do
    it 'should return a valid group' do
      bucket_maker.bucketize(existing_series, existing_bucket).should == existing_group
    end
  end

  context '#bucketable?' do
    it 'should return true for valid params' do
      bucket_maker.bucketable?(user, existing_series, existing_bucket, existing_group).should be_true
    end

    it 'should return false for invalid params' do
      bucket_maker.bucketable?(user, 'non_existing_series', existing_bucket, existing_group).should be_false
    end
  end
end
