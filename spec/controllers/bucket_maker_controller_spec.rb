require 'spec_helper'
require 'json'

describe BucketMakerController do

  let(:user) { build(:user) }

  before do
    ApplicationController.any_instance.stub(:set_current_user) { true }
    controller.instance_variable_set(:@current_user, user)
  end

  context 'with no current user' do
    before do
      controller.instance_variable_set(:@current_user, nil)
    end

    context 'for get group' do
      before { get :show, series_name: 'test_series_one', bucket_name: 'actual_test_one', group_name: 'group_one'}

      it 'returns failure' do
        response.should_not be_success
      end
    end

    context 'for forced set group' do
      before { post :switch, series_name: 'test_series_one', bucket_name: 'actual_test_one', group_name: 'group_one'}

      it 'returns failure' do
        response.should_not be_success
      end
    end

    context 'for randomized set group' do
      before { post :randomize, series_name: 'test_series_one', bucket_name: 'actual_test_one'}

      it 'returns failure' do
        response.should_not be_success
      end
    end
  end

  context 'with current user' do
    context 'with out the correct params' do
      context 'for get group' do
        before { get :show, series_name: 'non_existant_series', bucket_name: 'actual_test_one', group_name: 'group_one'}

        it 'returns failure' do
          response.should_not be_success
        end
      end

      context 'for forced set group' do
        before { post :switch, series_name: 'non_existant_series', bucket_name: 'actual_test_one', group_name: 'group_one'}

        it 'returns failure' do
          response.should_not be_success
        end
      end

      context 'for randomized set group' do
        before { post :randomize, series_name: 'non_existant_series', bucket_name: 'actual_test_one'}

        it 'returns failure' do
          response.should_not be_success
        end
      end
    end

    context 'for get group' do
      it 'returns success' do
        get :show, series_name: 'test_series_one', bucket_name: 'actual_test_one', group_name: 'group_one'
        response.should be_success
      end

      context 'for the correct bucket' do
        before do
          user.stub(:in_bucket?).with('test_series_one', 'actual_test_one', 'group_one') { true }
          get :show, series_name: 'test_series_one', bucket_name: 'actual_test_one', group_name: 'group_one'
        end

        it 'has a true response' do
          response.body.should include('true')
        end
      end
    end

    context 'for forced set group' do
      before { post :switch, series_name: 'test_series_one', bucket_name: 'actual_test_one', group_name: 'group_one'}

      it 'returns success' do
        response.should be_success
      end

      it 'has a true response' do
        response.body.should include('true')
      end
    end

    context 'for randomized set group' do
      before { post :randomize, series_name: 'test_series_one', bucket_name: 'actual_test_one'}

      it 'returns success' do
        response.should be_success
      end

      it 'has a true response' do
        response.body.should include('true')
      end
    end
  end
end
