require 'rails/generators/base'

module BucketMaker
  module Generators
    # Installs the initializer
    #
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a BucketMaker initializer"

      # Copies the initializer bucket_maker from the templates and pastes
      #
      def copy_initializer
        template "bucket_maker.rb", "config/initializers/bucket_maker.rb"
      end

    end
  end
end
