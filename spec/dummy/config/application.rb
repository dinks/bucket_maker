require File.expand_path('../boot', __FILE__)

require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"

Bundler.require(:default, Rails.env)
require "bucket_maker"

module Dummy
  class Application < Rails::Application
    # For Ruby 1.9
    config.encoding = "utf-8"
    config.secret_key_base = 'Testme'
  end
end
