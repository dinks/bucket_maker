class BucketMakerController < ApplicationController
  include BucketMakerConcern

  def show
    if BucketMaker.buckets_configuration.has_group_in_bucket_in_series?(@series_name, @bucket_name, @group_name)
      render text: @current_user.in_bucket?(@series_name, @bucket_name, @group_name)
    else
      head :not_found
    end
  end

  def switch
    if BucketMaker.buckets_configuration.has_group_in_bucket_in_series?(@series_name, @bucket_name, @group_name)
      render text: @current_user.force_to_bucket!(@series_name, @bucket_name, @group_name)
    else
      head :not_found
    end
  end

  def randomize
    if BucketMaker.buckets_configuration.has_bucket_in_series?(@series_name, @bucket_name)
      render text: @current_user.bucketize_for_series_and_bucket!(@series_name, @bucket_name)
    else
      head :not_found
    end
  end

end
