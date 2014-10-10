require 'spec_helper'

describe BucketMaker::SeriesMaker do
  let(:bucket_maker) { BucketMaker::SeriesMaker.instance }
  let(:user) { build(:user, id: 12345) }
  let(:existing_series) { 'test_series_one' }
  let(:existing_bucket) { 'actual_test_one' }
  let(:existing_group)  { 'group_two' }
  let(:non_existing_series) { 'non_existing_series' }

  before do
    allow_any_instance_of(BucketMaker::Bucket).to receive(:random_group).and_return(existing_group)
  end

  context 'for configuration' do
    let(:series) { bucket_maker.series_with_name(existing_series) }

    it 'should have correct number of series' do
      expect(bucket_maker.series.keys.length).to eql(2) # Look at config/buckets.yml
    end

    it 'should have correct number of buckets' do
      expect(series.buckets.keys.length).to eql(2)
    end

    it 'should have correct number of distribut' do
      expect(series.bucket_with_name(existing_bucket).distributions.keys.length).to eql(3)
    end
  end

  context '#configured?' do
    subject { bucket_maker.configured? }

    it 'should be configured' do
      expect(subject).to eql(true)
    end
  end

  context '#key_for_series' do
    subject { bucket_maker.key_for_series(user, 'series_one', 'bucket_one') }

    it 'should return the correct key' do
      expect(subject).to eql('bucket_maker:user_12345:series_one:bucket_one')
    end
  end

  context '#has_series?' do
    subject { bucket_maker.has_series?(series) }

    context 'for an existing series' do
      let(:series) { existing_series }

      it 'should return true' do
        expect(subject).to eql(true)
      end
    end

    context 'for a non existing series' do
      let(:series) { non_existing_series }

      it 'should return false' do
        expect(subject).to eql(false)
      end
    end
  end

  context '#series_with_name' do
    subject { bucket_maker.series_with_name(existing_series) }

    it 'should return a Series object' do
      expect(subject).to be_kind_of(BucketMaker::Series)
    end
  end

  context '#has_bucket_in_series?' do
    subject { bucket_maker.has_bucket_in_series?(series, existing_bucket) }

    context 'for an existing bucket' do
      let(:series) { existing_series }

      it 'should return true' do
        expect(subject).to eql(true)
      end
    end

    context 'for a non existing bucket' do
      let(:series) { non_existing_series }

      it 'should return false' do
        expect(subject).to eql(false)
      end
    end
  end

  context '#has_group_in_bucket_in_series?' do
    subject { bucket_maker.has_group_in_bucket_in_series?(series, existing_bucket, existing_group) }

    context 'for an existing group' do
      let(:series) { existing_series }

      it 'should return true' do
        expect(subject).to eql(true)
      end
    end

    context 'for a non existing group' do
      let(:series) { non_existing_series }

      it 'should return false' do
        expect(subject).to eql(false)
      end
    end
  end

  context '#bucketize' do
    subject { bucket_maker.bucketize(existing_series, existing_bucket) }

    it 'should return a valid group' do
      expect(subject).to eql(existing_group)
    end
  end

  context '#bucketable?' do
    subject { bucket_maker.bucketable?(user, series, existing_bucket, existing_group) }

    context 'for valid params' do
      let(:series) { existing_series }

      it 'should return true' do
        expect(subject).to eql(true)
      end
    end

    context 'for invalid params' do
      let(:series) { non_existing_series }

      it 'should return false' do
        expect(subject).to eql(false)
      end
    end
  end
end
