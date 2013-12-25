class BucketMakerController < ApplicationController
  include BucketMakerConcern

  before_filter :ensure_valid_series_bucket_group, only: [:show, :switch]
  before_filter :ensure_valid_series_bucket, only: [:randomize]

  def show
    render text: @current_user.in_bucket?(@series_name, @bucket_name, @group_name)
  end

  def switch
    render text: @current_user.force_to_bucket!(@series_name, @bucket_name, @group_name)
  end

  def randomize
    render text: @current_user.bucketize_for_series_and_bucket!(@series_name, @bucket_name)
  end

  private
  def ensure_valid_series_bucket_group
    not_found unless BucketMaker.buckets_configuration.has_group_in_bucket_in_series?(@series_name, @bucket_name, @group_name)
  end

  def ensure_valid_series_bucket
    not_found unless BucketMaker.buckets_configuration.has_bucket_in_series?(@series_name, @bucket_name)
  end

  def not_found
    head :not_found
    false
  end
end
