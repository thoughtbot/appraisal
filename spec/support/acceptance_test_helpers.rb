require 'rspec/expectations/expectation_target'
require 'active_support/core_ext/string/strip'
require 'active_support/concern'
require './features/support/dependency_helpers'

module AcceptanceTestHelpers
  extend ActiveSupport::Concern
  include Aruba::Api
  include DependencyHelpers

  included do
    metadata[:type] = :acceptance

    before :all do
      initialize_aruba_instance_variables
      build_default_dummy_gems
    end

    before do
      cleanup_artifacts
      build_default_gemfile
      unset_bundler_env_vars
      ENV["GEM_PATH"] = [TMP_GEM_ROOT, ENV["GEM_PATH"]].join(":")
    end

    after do
      restore_env
    end
  end

  def build_appraisal_file(content)
    write_file 'Appraisals', content.strip_heredoc
  end

  def build_gemfile(content)
    write_file 'Gemfile', content.strip_heredoc
  end

  def expect_file(filename)
    expect(filename)
  end

  def contains(expected)
    FileContentMatcher.new(expected)
  end

  def be_exists
    FileExistsMatcher.new
  end

  private

  def cleanup_artifacts
    FileUtils.rm_rf(current_dir)
  end

  def initialize_aruba_instance_variables
    @announce_stdout = nil
    @announce_stderr = nil
    @announce_cmd = nil
    @announce_dir = nil
    @announce_env = nil
    @aruba_timeout_seconds = 60
    @aruba_io_wait_seconds = nil
  end

  def build_default_dummy_gems
    FileUtils.rm_rf(TMP_GEM_ROOT)
    FileUtils.mkdir_p(TMP_GEM_ROOT)

    build_gem 'dummy', '1.0.0'
    build_gem 'dummy', '1.1.0'
  end

  def build_default_gemfile
    build_gemfile <<-Gemfile
      source 'https://rubygems.org'

      gem 'dummy'
      gem 'appraisal', :path => '#{PROJECT_ROOT}'
    Gemfile
  end

  class FileExistsMatcher
    include Aruba::Api

    def matches?(expected)
      @expected = expected
      in_current_dir { File.exists?(@expected) }
    end

    def failure_message_for_should
      "file #{@expected.inspect} does not exist.\n"
    end

    def failure_message_for_should_not
      "file #{@expected.inspect} exists.\n"
    end
  end

  class FileContentMatcher < RSpec::Matchers::BuiltIn::Eq
    include Aruba::Api

    def matches?(filename)
      @actual = in_current_dir { File.read(filename) }
      expected == actual
    end
  end
end
