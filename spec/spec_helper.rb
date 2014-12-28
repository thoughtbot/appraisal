require 'rubygems'
require 'bundler/setup'
require_relative 'support/acceptance_test_helpers'
require_relative 'support/stream_helpers'

PROJECT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..')).freeze
TMP_GEM_ROOT = File.join(PROJECT_ROOT, "tmp", "gems")

RSpec.configure do |config|
  config.raise_errors_for_deprecations!

  config.define_derived_metadata(:file_path => %r{spec\/acceptance\/}) do |metadata|
    metadata[:type] = :acceptance
  end

  config.include AcceptanceTestHelpers, :type => :acceptance
end
