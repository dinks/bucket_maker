require 'rails/generators/base'

module BucketMaker
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a BucketMaker initializer"

      def copy_initializer
        template "bucket_maker.rb", "config/initializers/bucket_maker.rb"
      end

    end
  end
end
