Rails.application.routes.draw do
  if BucketMaker.configured? && BucketMaker.load_routes?

    # Show if the user is in group
    #
    get   "/#{BucketMaker.configuration.path_prefix}:series_name/:bucket_name/:group_name", to: 'bucket_maker#show', as: :show_bucket, format: :json

    # Randomize group
    #
    post   "/#{BucketMaker.configuration.path_prefix}:series_name/:bucket_name", to: 'bucket_maker#randomize', as: :randomize_bucket, format: :json

    # Force Switch group
    #
    post   "/#{BucketMaker.configuration.path_prefix}:series_name/:bucket_name/:group_name", to: 'bucket_maker#switch', as: :switch_bucket, format: :json

  end
end
