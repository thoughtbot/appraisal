# frozen_string_literal: true

require "rubygems"

if ENV["CI"].nil? && ENV["DEBUG"] == "true"
  ENV["VERBOSE"] = "true"
  ruby_version = Gem::Version.new(RUBY_VERSION)
  if ruby_version < Gem::Version.new("2.7")
    # Use byebug in code
    require "byebug"
  else
    # Use binding.break, binding.b, or debugger in code
    require "debug"
  end
end

# External Libraries
require "active_support/core_ext/string/strip"
require "rspec/pending_for"

# This library
require "support/dependency_helpers"
require "support/acceptance_test_helpers"
require "support/stream_helpers"

PROJECT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), "..")).freeze
TMP_GEM_ROOT = File.join(PROJECT_ROOT, "tmp", "bundler")
TMP_GEM_BUILD = File.join(PROJECT_ROOT, "tmp", "build")
ENV["APPRAISAL_UNDER_TEST"] = "1"

RSpec.configure do |config|
  config.raise_errors_for_deprecations!

  config.define_derived_metadata(:file_path => %r{spec/acceptance/}) do |metadata|
    metadata[:type] = :acceptance
  end

  config.include AcceptanceTestHelpers, :type => :acceptance

  # disable monkey patching
  # see: https://relishapp.com/rspec/rspec-core/v/3-8/docs/configuration/zero-monkey-patching-mode
  config.disable_monkey_patching!

  config.before :suite do
    FileUtils.rm_rf TMP_GEM_ROOT
    FileUtils.rm_rf TMP_GEM_BUILD
  end
end
