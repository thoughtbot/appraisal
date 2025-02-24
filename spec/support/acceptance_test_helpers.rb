# frozen_string_literal: true

# External Libraries
require "rspec/expectations/expectation_target"
require "active_support/core_ext/string/filters"
require "active_support/concern"

# This library
require "appraisal/utils"

module AcceptanceTestHelpers
  extend ActiveSupport::Concern
  include DependencyHelpers

  BUNDLER_ENVIRONMENT_VARIABLES = %w[
    RUBYOPT
    BUNDLE_PATH
    BUNDLE_BIN_PATH
    BUNDLE_GEMFILE
    BUNDLER_SETUP
  ].freeze

  included do
    metadata[:type] = :acceptance

    before :parallel => true do
      unless Appraisal::Utils.support_parallel_installation?
        skip "This Bundler version does not support --jobs flag."
      end
    end

    before :git_local => true do
      unless Appraisal::Utils.support_git_local_installation?
        skip "This Bundler version does not support sourcing gems from git repos on local filesystem."
      end
    end

    before do
      cleanup_artifacts
      save_environment_variables
      unset_bundler_environment_variables
      build_default_dummy_gems
      ensure_bundler_is_available
      add_binstub_path
      build_default_gemfile
    end

    after do
      restore_environment_variables
    end
  end

  # A head version of MRI ruby will require the -dev appended to the ruby string in the gemfile.
  # Unfortunately, there is no ENV variable that has access to the "dev" concept directly.
  # Perhaps the best we can do is parse RUBY_DESCRIPTION?
  #   > RUBY_DESCRIPTION
  #   "ruby 3.5.0dev (2025-02-20T18:14:37Z ... etc)
  def ruby_dev_append
    RUBY_DESCRIPTION.include?("dev") ? "-dev" : ""
  end

  def save_environment_variables
    @original_environment_variables = {}

    (BUNDLER_ENVIRONMENT_VARIABLES + %w[PATH]).each do |key|
      @original_environment_variables[key] = ENV[key]
    end
  end

  def unset_bundler_environment_variables
    BUNDLER_ENVIRONMENT_VARIABLES.each do |key|
      ENV[key] = nil
    end
  end

  def add_binstub_path
    ENV["PATH"] = "bin:#{ENV["PATH"]}"
  end

  def restore_environment_variables
    @original_environment_variables.each_pair do |key, value|
      ENV[key] = value
    end
  end

  def build_appraisal_file(content)
    write_file "Appraisals", content.strip_heredoc
  end

  def build_gemfile(content)
    write_file "Gemfile", content.strip_heredoc
  end

  def add_gemspec_to_gemfile
    in_test_directory do
      File.open("Gemfile", "a") { |file| file.puts "gemspec" }
    end
  end

  def build_gemspec
    write_file "stage.gemspec", <<-GEMSPEC.strip_heredoc.rstrip
      Gem::Specification.new do |s|
        s.name = 'stage'
        s.version = '0.1'
        s.summary = 'Awesome Gem!'
        s.authors = "Appraisal"
      end
    GEMSPEC
  end

  def content_of(path)
    file(path).read.tap do |content|
      content.gsub!(/(\S+): /, ':\\1 => ')
    end.strip
  end

  def file(path)
    Pathname.new(current_directory) + path
  end

  def be_exists
    be_exist
  end

  private

  def current_directory
    File.expand_path("tmp/stage")
  end

  def write_file(filename, content)
    in_test_directory { File.open(filename, "w") { |file| file.puts content } }
  end

  def cleanup_artifacts
    FileUtils.rm_rf current_directory
  end

  def build_default_dummy_gems
    FileUtils.mkdir_p(TMP_GEM_ROOT)

    build_gem "dummy", "1.0.0"
    build_gem "dummy", "1.1.0"
  end

  def ensure_bundler_is_available
    run "bundle -v 2>&1", false

    return unless $?.exitstatus != 0

    puts <<-WARNING.strip_heredoc.rstrip
      Reinstall Bundler to #{TMP_GEM_ROOT} as `BUNDLE_DISABLE_SHARED_GEMS`
      is enabled.
    WARNING
    version = Utils.bundler_version

    run "gem install bundler --version #{version} --install-dir '#{TMP_GEM_ROOT}'"
  end

  def build_default_gemfile
    build_gemfile <<-GEMFILE.strip_heredoc.rstrip
      source 'https://rubygems.org'

      gem 'appraisal', :path => '#{PROJECT_ROOT}'
    GEMFILE

    run "bundle install --local"
    # Support for binstubs --all was added to bundler's 1-17-stable branch
    #   and released with bundler v1.17.0.pre.2 (2018-10-13)
    # See:
    #   - https://github.com/rubygems/bundler/pull/6450
    #   - https://github.com/rubygems/bundler/commit/9d59fa41ef43aaccc6cf867a69a49648510c4df7#diff-06572a96a58dc510037d5efa622f9bec8519bc1beab13c9f251e97e657a9d4edR10
    run "bundle binstubs --all"
  end

  def in_test_directory(&block)
    FileUtils.mkdir_p current_directory
    Dir.chdir current_directory, &block
  end

  def run(command, raise_on_error = true)
    in_test_directory do
      %x(#{command}).tap do |output|
        exitstatus = $?.exitstatus

        puts output if ENV["VERBOSE"]

        if raise_on_error && exitstatus != 0
          raise <<-ERROR_MESSAGE.strip_heredoc.rstrip
            Command #{command.inspect} exited with status #{exitstatus}. Output:
            #{output.gsub(/^/, "  ")}
          ERROR_MESSAGE
        end
      end
    end
  end
end
