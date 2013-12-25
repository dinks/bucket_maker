require 'spec_helper'

describe BucketMaker::Bucket do
  let(:bucket_options) do
    {
      'description' => 'Test One',
      'created_after' => "2nd Jan 2010",
      'distributions' => {
        'group_one' => 0.3,
        'group_two' => 0.5,
        'group_three' => 0.2,
      }
    }
  end

  let(:bucket) { BucketMaker::Bucket.new('test_bucket', bucket_options) }

  context 'for configuration' do
    it 'should have the correct distributions' do
      bucket.distributions[:group_one].should == 0.3
      bucket.distributions[:group_two].should == 0.5
      bucket.distributions[:group_three].should == 0.2
    end

    context 'and distributions percent' do
      before { bucket.random_group }

      it 'should have the correct distribution percentages' do
        bucket.distributions_percent[:group_one].should == (0..30)
        bucket.distributions_percent[:group_two].should == (30..80)
        bucket.distributions_percent[:group_three].should == (80..100)
      end
    end
  end

  context '#is_bucketable?' do
    it 'should return false if created after doesnt satisfy' do
      user = build(:user, id: 12345, created_at: DateTime.parse('1st Jan 2010'))
      bucket.is_bucketable?(user).should be_false
    end

    it 'should return true if created after does satisfy' do
      user = build(:user, id: 12345, created_at: DateTime.parse('3rd Jan 2010'))
      bucket.is_bucketable?(user).should be_true
    end
  end

  context '#has_group?' do
    it 'should return false for non existant group' do
      bucket.has_group?('non_existant_test').should be_false
    end

    it 'should return true for existing group' do
      bucket.has_group?('group_two').should be_true
    end
  end
end
