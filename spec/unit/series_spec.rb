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
  let(:existant_bucket) { 'actual_test_one' }
  let(:non_existant_bucket) { 'non_existant_test' }

  context '#bucket_with_name' do
    subject { series.bucket_with_name(bucket) }

    context 'with an existing bucket' do
      let(:bucket) { existant_bucket }

      it 'should return a Bucket object' do
        expect(subject).to be_kind_of(BucketMaker::Bucket)
      end
    end

    context 'with a non existing bucket' do
      let(:bucket) { non_existant_bucket }

      it 'should return nil' do
        expect(subject).to be_nil
      end
    end
  end

  context '#is_bucketable?' do
    subject { series.is_bucketable?(user) }

    context 'when created after doesnt satisfy' do
      let(:user) { build(:user, id: 12345, created_at: DateTime.parse('1st Jan 2010')) }

      it 'should return false' do
        expect(subject).to eql(false)
      end
    end

    context 'when created after does satisfy' do
      let(:user) { build(:user, id: 12345, created_at: DateTime.parse('3rd Jan 2010')) }

      it 'should return true' do
        expect(subject).to eql(true)
      end
    end
  end

  context '#has_bucket?' do
    subject { series.has_bucket?(bucket) }

    context 'for non existant bucket' do
      let(:bucket) { non_existant_bucket }

      it 'should return false' do
        expect(subject).to eql(false)
      end
    end

    context 'for non existant bucket' do
      let(:bucket) { existant_bucket }

      it 'should return true' do
        expect(subject).to eql(true)
      end
    end
  end

  context '#has_group_in_bucket?' do
    subject { series.has_group_in_bucket?(existant_bucket, group) }

    context 'for non existant group' do
      let(:group) { 'non_existant_test' }

      it 'should return false' do
        expect(subject).to eql(false)
      end
    end

    context 'for an existant group' do
      let(:group) { 'group_two' }

      it 'should return true' do
        expect(subject).to eql(true)
      end
    end
  end
end
