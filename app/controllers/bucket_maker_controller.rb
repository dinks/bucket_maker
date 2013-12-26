class BucketMakerController < ApplicationController
  include BucketMakerConcern

  before_filter :ensure_valid_series_bucket_group, only: [:show, :switch]
  before_filter :ensure_valid_series_bucket, only: [:randomize]

  # Show if the group for the current_user is the same as stored
  #
  def show
    render text: @current_user.in_bucket?(@series_name, @bucket_name, @group_name)
  end

  # Switch the current user to group_name
  #
  def switch
    render text: @current_user.force_to_bucket!(@series_name, @bucket_name, @group_name)
  end

  # Randomize the current_user for series_name and bucket_name
  #
  def randomize
    render text: @current_user.bucketize_for_series_and_bucket!(@series_name, @bucket_name)
  end

  private

  # Ensure we have valid attributes
  #
  def ensure_valid_series_bucket_group
    not_found unless BucketMaker.buckets_configuration.has_group_in_bucket_in_series?(@series_name, @bucket_name, @group_name)
  end

  # Ensure we have valid attributes
  #
  def ensure_valid_series_bucket
    not_found unless BucketMaker.buckets_configuration.has_bucket_in_series?(@series_name, @bucket_name)
  end

  # Head not found for invalid requests
  #
  def not_found
    head :not_found
    false
  end
end
