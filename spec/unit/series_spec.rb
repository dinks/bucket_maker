require 'spec_helper'

describe BucketMaker::Series do
  let(:series_options) do
    {
      'description' => 'Some lame description for the Series',
      'created_after' => "2nd Jan 2010",
      'buckets' => {
        'actual_test_one' => {
          'description' => 'Test One',
          'distributions' => {
            'group_one' => 0.3,
            'group_two' => 0.5,
            'group_three' => 0.2,
          }
        }
      }
    }
  end

  let(:series) { BucketMaker::Series.new('test_series', series_options) }

  context '#bucket_with_name' do
    it 'should return a Bucket object' do
      series.bucket_with_name('actual_test_one').should be_kind_of(BucketMaker::Bucket)
    end

    it 'should return a Bucket object' do
      series.bucket_with_name('non_existant_test').should be_nil
    end
  end

  context '#is_bucketable?' do
    it 'should return false if created after doesnt satisfy' do
      user = build(:user, id: 12345, created_at: DateTime.parse('1st Jan 2010'))
      series.is_bucketable?(user).should be_false
    end

    it 'should return true if created after does satisfy' do
      user = build(:user, id: 12345, created_at: DateTime.parse('3rd Jan 2010'))
      series.is_bucketable?(user).should be_true
    end
  end

  context '#has_bucket?' do
    it 'should return false for non existant bucket' do
      series.has_bucket?('non_existant_test').should be_false
    end

    it 'should return true for existing bucket' do
      series.has_bucket?('actual_test_one').should be_true
    end
  end

  context '#has_group_in_bucket?' do
    it 'should return false for non existant group' do
      series.has_group_in_bucket?('actual_test_one', 'non_existant_test').should be_false
    end

    it 'should return false for non existant group' do
      series.has_group_in_bucket?('actual_test_one', 'group_two').should be_true
    end
  end
end
