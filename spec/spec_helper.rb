require 'rubygems'
require 'bundler/setup'
require './spec/support/acceptance_test_helpers'

PROJECT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..')).freeze
TMP_GEM_ROOT = File.join(PROJECT_ROOT, "tmp", "gems")

RSpec.configure do |config|
  config.include AcceptanceTestHelpers, :type => :acceptance, :example_group => {
    :file_path => %r{spec\/acceptance\/}
  }
end
