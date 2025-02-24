# frozen_string_literal: true

require "spec_helper"

RSpec.describe "eval_gemfile" do
  before do
    build_appraisal_file
    build_modular_gemfile
    build_rakefile
    build_gemspec
  end

  it "supports eval_gemfile syntax" do
    write_file "Gemfile", <<-GEMFILE
      source "https://rubygems.org"

      gem 'appraisal', :path => #{PROJECT_ROOT.inspect}

      gemspec
    GEMFILE

    run "bundle install --local"
    run "appraisal install"
    output = run "appraisal rake version"

    expect(output).to include "Loaded 1.1.0"
  end

  def build_modular_gemfile
    begin
      Dir.mkdir("tmp/stage/gemfiles")
    rescue
      nil
    end

    write_file File.join("gemfiles", "im_with_dummy"), <<-GEMFILE
      # No source needed because this is a modular gemfile intended to be loaded into another gemfile,
      #   which will define source.
      gem 'dummy'
    GEMFILE
  end

  def build_appraisal_file
    super(<<-APPRAISALS)
      appraise 'stock' do
        gem 'rake'
        eval_gemfile "im_with_dummy"
      end
    APPRAISALS
  end

  def build_rakefile
    write_file "Rakefile", <<-RAKEFILE
      require 'rubygems'
      require 'bundler/setup'
      require 'appraisal'

      task :version do
        require 'dummy'
        puts "Loaded \#{$dummy_version}"
      end
    RAKEFILE
  end

  def build_gemspec(path = ".")
    begin
      Dir.mkdir("tmp/stage/#{path}")
    rescue
      nil
    end

    write_file File.join(path, "gemspec_project.gemspec"), <<-GEMSPEC
      Gem::Specification.new do |s|
        s.name = 'gemspec_project'
        s.version = '0.1'
        s.summary = 'Awesome Gem!'
        s.authors = "Appraisal"
      end
    GEMSPEC
  end
end
