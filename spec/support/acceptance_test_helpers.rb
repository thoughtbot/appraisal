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

    after :all do
      cleanup_default_gems
    end

    before parallel: true do
      unless Appraisal::Utils.support_parallel_installation?
        pending 'This Bundler version does not support --jobs flag.'
      end
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

  def add_gemspec_to_gemfile
    append_to_file 'gemfile', 'gemspec'
  end

  def build_gemspec
    gem_name = dirs.last

    write_file "#{gem_name}.gemspec", <<-gemspec
      Gem::Specification.new do |s|
        s.name = '#{gem_name}'
        s.version = '0.1'
        s.summary = 'Awesome Gem!'
      end
    gemspec
  end

  def content_of(path)
    file(path).read
  end

  def file(path)
    Pathname.new(current_dir) + path
  end

  def be_exists
    be_exist
  end

  private

  def cleanup_artifacts
    FileUtils.rm_rf(current_dir)
  end

  def cleanup_default_gems
    FileUtils.rm_rf(TMP_GEM_ROOT)
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
end
