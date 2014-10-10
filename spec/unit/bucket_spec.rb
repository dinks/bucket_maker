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
      expect(bucket.distributions[:group_one]).to eql(0.3)
      expect(bucket.distributions[:group_two]).to eql(0.5)
      expect(bucket.distributions[:group_three]).to eql(0.2)
    end

    context 'and distributions percent' do
      before { bucket.random_group }

      it 'should have the correct distribution percentages' do
        expect(bucket.distributions_percent[:group_one]).to eql(0..30.0)
        expect(bucket.distributions_percent[:group_two]).to eql(30.0..80.0)
        expect(bucket.distributions_percent[:group_three]).to eql(80.0..100.0)
      end
    end
  end

  context '#is_bucketable?' do
    subject { bucket.is_bucketable?(user) }

    context 'created after doesnt satisfy' do
      let(:user) { build(:user, id: 12345, created_at: DateTime.parse('1st Jan 2010')) }

      it 'should return false' do
        expect(subject).to eql(false)
      end
    end

    context 'created after does satisfy' do
      let(:user) { build(:user, id: 12345, created_at: DateTime.parse('3rd Jan 2010')) }

      it 'should return true' do
        expect(subject).to eql(true)
      end
    end
  end

  context '#has_group?' do
    subject { bucket.has_group?(group) }

    context 'for non existant group' do
      let(:group) { 'non_existant_test' }

      it 'should return false' do
        expect(subject).to eql(false)
      end
    end

    context 'for existing group' do
      let(:group) { 'group_two' }

      it 'should return true' do
        expect(subject).to eql(true)
      end
    end
  end
end
