require 'spec_helper'

describe 'Routes' do
  context 'with default routes' do
    it 'should have get bucket route' do
      expect(get: '/2bOrNot2B/test_series_one/actual_test_one/group_one.json').to route_to(
        controller:         'bucket_maker',
        action:             'show',
        series_name:        'test_series_one',
        bucket_name:        'actual_test_one',
        group_name:         'group_one',
        format:             'json'
      )
    end

    it 'should have force set bucket route' do
      expect(post: '/2bOrNot2B/test_series_one/actual_test_one/group_one.json').to route_to(
        controller:         'bucket_maker',
        action:             'switch',
        series_name:        'test_series_one',
        bucket_name:        'actual_test_one',
        group_name:         'group_one',
        format:             'json'
      )
    end

    it 'should have randomize bucket route' do
      expect(post: '/2bOrNot2B/test_series_one/actual_test_one.json').to route_to(
        controller:         'bucket_maker',
        action:             'randomize',
        series_name:        'test_series_one',
        bucket_name:        'actual_test_one',
        format:             'json'
      )
    end
  end

  context 'with special prefix' do
    around do |example|
      default_base_path = BucketMaker.configuration.path_prefix
      BucketMaker.configuration.path_prefix = 'non_default_path'

      Rails.application.reload_routes!

      BucketMaker.configuration.path_prefix = default_base_path
      Rails.application.reload_routes!
    end

    it 'should have get bucket route' do
      expect(get: '/non_default_path/test_series_one/actual_test_one/group_one.json').to route_to(
        controller:         'bucket_maker',
        action:             'show',
        series_name:        'test_series_one',
        bucket_name:        'actual_test_one',
        group_name:         'group_one',
        format:             'json'
      )
    end

    it 'should have force set bucket route' do
      expect(post: '/non_default_path/test_series_one/actual_test_one/group_one.json').to route_to(
        controller:         'bucket_maker',
        action:             'switch',
        series_name:        'test_series_one',
        bucket_name:        'actual_test_one',
        group_name:         'group_one',
        format:             'json'
      )
    end

    it 'should have randomize bucket route' do
      expect(post: '/non_default_path/test_series_one/actual_test_one.json').to route_to(
        controller:         'bucket_maker',
        action:             'randomize',
        series_name:        'test_series_one',
        bucket_name:        'actual_test_one',
        format:             'json'
      )
    end
  end
end
