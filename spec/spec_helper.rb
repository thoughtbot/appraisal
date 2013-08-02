require 'rubygems'
require 'bundler/setup'
require 'aruba/api'
require 'active_support/core_ext/string/strip'
require './features/support/dependency_helpers'

PROJECT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..')).freeze
TMP_GEM_ROOT = File.join(PROJECT_ROOT, "tmp", "gems")

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f }

RSpec.configure do |config|
  config.include Aruba::Api
  config.include AppraisalHelpers
  config.include DependencyHelpers
end
