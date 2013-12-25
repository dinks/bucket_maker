require 'spec_helper'

describe BucketMaker::Models::Bucketable do
  class DummyClass
    def id; 12345; end
  end

  let(:dummy) { DummyClass.new }
  let(:existing_series) { 'test_series_one' }
  let(:existing_bucket) { 'actual_test_one' }
  let(:existing_group)  { 'group_two' }

  before do
    dummy.extend BucketMaker::Models::Bucketable
  end

  context '#group_for_key' do
    it 'should raise exception' do
      expect {
        dummy.send(:group_for_key, 'test_series')
      }.to raise_error
    end
  end

  context '#set_group_for_key' do
    it 'should raise exception' do
      expect {
        dummy.send(:set_group_for_key, 'test_series', 'test_group')
      }.to raise_error NotImplementedError
    end
  end

  context 'with stubbed group_for_key and set_group_for_key' do
    before do
      dummy.stub(:group_for_key) { true }
      dummy.stub(:set_group_for_key) { true }
      dummy.stub(:has_attribute?) { true }
      dummy.stub(:created_at) { DateTime.parse('1st Jan 2010') }
    end

    context '#in_bucket?' do
      context 'with invalid params' do
        it 'should return false' do
          dummy.in_bucket?('non_existant_series', existing_bucket, existing_group).should be_false
        end
      end

      context 'with valid params' do
        it 'should return false' do
          # group_for_key return true and true == existing_group is false
          dummy.in_bucket?(existing_series, existing_bucket, existing_group).should be_false
        end

        context 'when group_for_key returns the current group' do
          before do
            dummy.stub(:group_for_key).with(anything()) { existing_group }
          end

          it 'should return true' do
            dummy.in_bucket?(existing_series, existing_bucket, existing_group).should be_true
          end
        end
      end
    end

    context '#force_to_bucket!' do
      context 'with invalid params' do
        it 'should return false' do
          dummy.force_to_bucket!('non_existant_series', existing_bucket, existing_group).should be_false
        end
      end

      context 'with valid params' do
        it 'should return true' do
          dummy.force_to_bucket!(existing_series, existing_bucket, existing_group).should be_true
        end
      end
    end

    context '#bucketize_for_series_and_bucket!' do
      context 'with invalid params' do
        it 'should return false' do
          dummy.bucketize_for_series_and_bucket!('non_existant_series', existing_bucket).should be_false
        end
      end

      context 'with valid params' do
        it 'should return true' do
          dummy.bucketize_for_series_and_bucket!(existing_series, existing_bucket).should be_true
        end
      end
    end

    context '#bucketize!' do
      it 'should return true' do
        dummy.bucketize!.should be_true
      end
    end
  end
end
