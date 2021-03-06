require 'rails/generators/active_record'

module ActiveRecord
  module Generators
    # Generator to create Active Record specific classes
    #
    class BucketMakerGenerator < ActiveRecord::Generators::Base

      ACTIVE_RECORDABLE = 'bucket'

      source_root File.expand_path("../../templates", __FILE__)
      argument :store_in, type: :string, default: 'redis'

      # Generate the model
      #
      # If store_in is active_record then the ACTIVE_RECORDABLE is also created which holds association
      #
      def generate_model
        invoke "active_record:model", [name], :migration => false unless model_exists? && behavior == :invoke
        if store_in == 'active_record'
          invoke "active_record:model", [ACTIVE_RECORDABLE], :migration => false unless active_recordable_exists? && behavior == :invoke
        end
      end

      # Inject the content to the models
      #
      # If store_in is actice_record then the ACTIVE_RECORDABLE is also inserted with association
      #
      def inject_bucket_maker_content
        contents = <<-CONTENT.strip_heredoc
          # Module Inclusion for BucketMaker
          # The options are
          # - BucketMaker::Models::Redisable
          #
          include #{module_name_for_include}

        CONTENT

        klass_path =  if namespaced?
                        class_name.to_s.split("::")
                      else
                        [class_name]
                      end

        indent_depth = klass_path.size
        contents = contents.split("\n").map { |line| " " * indent_depth + line } .join("\n") << "\n\n"

        inject_into_class(model_path, klass_path.last, contents) if model_exists?

        inject_for_active_recordable if store_in == 'active_record' && active_recordable_exists?
      end

      # Content for association if store_in is active_record
      #
      def inject_for_active_recordable
        ar_contents = <<-CONTENT.strip_heredoc
            # Association with the bucket
            belongs_to :bucketable, polymorphic: true
          CONTENT

          ar_contents = ar_contents.split("\n").map { |line| " " + line } .join("\n") << "\n\n"

          inject_into_class(active_recordable_path, ACTIVE_RECORDABLE.camelize, ar_contents)
      end

      # Migration copier
      #
      # If store_in is actice_record then the migration runs
      #
      def copy_bucket_maker_migration
        if behavior == :invoke && store_in == 'active_record' && active_recordable_exists?
          migration_template "active_recordable_migration.rb", "db/migrate/create_#{ACTIVE_RECORDABLE.pluralize}"
        end
      end

      private

      # Check if the MODEL exists
      #
      def model_exists?
        File.exists?(File.join(destination_root, model_path))
      end

      # Check if the association exists
      #
      def active_recordable_exists?
        File.exists?(File.join(destination_root, active_recordable_path))
      end

      # Get the association path
      #
      def active_recordable_path
        @ar_path ||= File.join("app", "models", "#{ACTIVE_RECORDABLE}.rb")
      end

      # Get the MODEL path
      #
      def model_path
        @model_path ||= File.join("app", "models", "#{file_path}.rb")
      end

      # Get the module name to the included for store_in values
      #
      def module_name_for_include
        case store_in
        when 'redis'
          'BucketMaker::Models::Redisable'
        when 'active_record'
          'BucketMaker::Models::ActiveRecordable'
        else
          'BucketMaker::Models::Redisable'
        end
      end
    end
  end
end
