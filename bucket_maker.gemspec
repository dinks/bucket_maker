# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bucket_maker/version'

Gem::Specification.new do |spec|

  spec.name          = "bucket_maker"
  spec.version       = BucketMaker::VERSION
  spec.authors       = ["Dinesh Vasudevan"]
  spec.email         = ["dinesh.vasudevan@gmail.com"]
  spec.description   = %q{ Create Simple A/B categories }
  spec.summary       = %q{ A Gem to categorize Objects into buckets. Typical use case is an A/B test for Users }
  spec.homepage      = "https://github.com/dinks/bucket_maker"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 1.9.3"

  spec.add_runtime_dependency "redis"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "activesupport", ">= 3.1.0" # For x.months
  spec.add_development_dependency "activerecord", ">= 3.1.0" # For model test
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "appraisal" # Check against different Rails Versions
  spec.add_development_dependency "capybara", "= 2.0.3"
  spec.add_development_dependency "pry-debugger"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "factory_girl_rails"
  spec.add_development_dependency "mock_redis"
  spec.add_development_dependency "coveralls"

end
