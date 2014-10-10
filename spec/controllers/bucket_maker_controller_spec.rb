require 'spec_helper'
require 'json'

describe BucketMakerController, type: :controller do

  let(:user) { build(:user) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:set_current_user).and_return(true)
    controller.instance_variable_set(:@current_user, user)
  end

  context 'with no current user' do
    before do
      controller.instance_variable_set(:@current_user, nil)
    end

    context 'for get group' do
      before { get :show, series_name: 'test_series_one', bucket_name: 'actual_test_one', group_name: 'group_one'}

      it 'returns failure' do
        expect(response.status).to eql(401)
      end
    end

    context 'for forced set group' do
      before { post :switch, series_name: 'test_series_one', bucket_name: 'actual_test_one', group_name: 'group_one'}

      it 'returns failure' do
        expect(response.status).to eql(401)
      end
    end

    context 'for randomized set group' do
      before { post :randomize, series_name: 'test_series_one', bucket_name: 'actual_test_one'}

      it 'returns failure' do
        expect(response.status).to eql(401)
      end
    end
  end

  context 'with current user' do
    context 'with out the correct params' do
      context 'for get group' do
        before { get :show, series_name: 'non_existant_series', bucket_name: 'actual_test_one', group_name: 'group_one'}

        it 'returns failure' do
          expect(response.status).to eql(404)
        end
      end

      context 'for forced set group' do
        before { post :switch, series_name: 'non_existant_series', bucket_name: 'actual_test_one', group_name: 'group_one'}

        it 'returns failure' do
          expect(response.status).to eql(404)
        end
      end

      context 'for randomized set group' do
        before { post :randomize, series_name: 'non_existant_series', bucket_name: 'actual_test_one'}

        it 'returns failure' do
          expect(response.status).to eql(404)
        end
      end
    end

    context 'for get group' do
      it 'returns success' do
        get :show, series_name: 'test_series_one', bucket_name: 'actual_test_one', group_name: 'group_one'
        expect(response.status).to eql(200)
      end

      context 'for the correct bucket' do
        before do
          allow(user).to receive(:in_bucket?).and_return(true)
          get :show, series_name: 'test_series_one', bucket_name: 'actual_test_one', group_name: 'group_one'
        end

        it 'has a true response' do
          expect(response.body).to include('true')
        end
      end
    end

    context 'for forced set group' do
      before { post :switch, series_name: 'test_series_one', bucket_name: 'actual_test_one', group_name: 'group_one'}

      it 'returns success' do
        expect(response.status).to eql(200)
      end

      it 'has a true response' do
        expect(response.body).to include('true')
      end
    end

    context 'for randomized set group' do
      before { post :randomize, series_name: 'test_series_one', bucket_name: 'actual_test_one'}

      it 'returns success' do
        expect(response.status).to eql(200)
      end

      it 'has a true response' do
        expect(response.body).to include('true')
      end
    end
  end
end
