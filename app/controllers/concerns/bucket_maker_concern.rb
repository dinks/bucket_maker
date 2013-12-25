module BucketMakerConcern
  extend ActiveSupport::Concern

  included do
    layout false

    before_filter :showable?, :extract_params

    private
    def showable?
      unless @current_user && BucketMaker.configured?
        head :unauthorized
        false
      end
    end

    def extract_params
      @series_name  = params[:series_name] || ''
      @bucket_name  = params[:bucket_name] || ''
      @group_name   = params[:group_name] || ''
    end
  end
end
