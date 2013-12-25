require 'rails/generators/named_base'

module BucketMaker
  module Generators
    class BucketMakerGenerator < Rails::Generators::NamedBase

      namespace 'bucket_maker'
      source_root File.expand_path("../../templates", __FILE__)

      desc "Generates the model with a given NAME (if it doesn't exist) and adds the hook for method calls"

      hook_for :orm
    end
  end
end
