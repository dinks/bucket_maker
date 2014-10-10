require 'spec_helper'

describe BucketMaker::Models::Bucketable do
  class DummyClass
    def id; 12345; end
  end

  let(:dummy) { DummyClass.new }
  let(:existing_series) { 'test_series_one' }
  let(:existing_bucket) { 'actual_test_one' }
  let(:existing_group)  { 'group_two' }
  let(:non_existant_series) { 'non_existant_series' }

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
      allow(dummy).to receive(:group_for_key).and_return(true)
      allow(dummy).to receive(:set_group_for_key).and_return(true)
      allow(dummy).to receive(:has_attribute?).and_return(true)
      allow(dummy).to receive(:created_at).and_return(DateTime.parse('1st Jan 2010'))
    end

    context '#in_bucket?' do
      context 'with invalid params' do
        subject { dummy.in_bucket?(non_existant_series, existing_bucket, existing_group) }

        it 'should return false' do
          expect(subject).to eql(false)
        end
      end

      context 'with valid params' do
        subject { dummy.in_bucket?(existing_series, existing_bucket, existing_group) }

        it 'should return false' do
          # group_for_key return true and true == existing_group is false
          expect(subject).to eql(false)
        end

        context 'when group_for_key returns the current group' do
          before do
            allow(dummy).to receive(:group_for_key).and_return(existing_group)
          end

          it 'should return true' do
            expect(subject).to eql(true)
          end
        end
      end
    end

    context '#force_to_bucket!' do
      subject { dummy.force_to_bucket!(series, existing_bucket, existing_group) }

      context 'with invalid params' do
        let(:series) { non_existant_series }

        it 'should return false' do
          expect(subject).to eql(false)
        end
      end

      context 'with valid params' do
        let(:series) { existing_series }

        it 'should return true' do
          expect(subject).to eql(true)
        end
      end
    end

    context '#bucketize_for_series_and_bucket!' do
      subject { dummy.bucketize_for_series_and_bucket!(series, existing_bucket) }

      context 'with invalid params' do
        let(:series) { non_existant_series }

        it 'should return false' do
          expect(subject).to eql(false)
        end
      end

      context 'with valid params' do
        let(:series) { existing_series }

        it 'should return true' do
          expect(subject).to eql(true)
        end
      end
    end

    context '#bucketize!' do
      it 'should return true' do
        expect(dummy.bucketize!).to eql(true)
      end
    end
  end
end
