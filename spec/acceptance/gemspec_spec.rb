require "spec_helper"

RSpec.describe "Gemspec" do
  before do
    build_appraisal_file
    build_rakefile
  end

  it "supports gemspec syntax with default options" do
    build_gemspec

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

  it "supports gemspec syntax with path option" do
    build_gemspec "specdir"

    write_file "Gemfile", <<-GEMFILE
      source "https://rubygems.org"

      gem 'appraisal', :path => #{PROJECT_ROOT.inspect}

      gemspec :path => './specdir'
    GEMFILE

    run "bundle install --local"
    run "appraisal install"
    output = run "appraisal rake version"

    expect(output).to include "Loaded 1.1.0"
  end

  def build_appraisal_file
    super <<-APPRAISALS
      appraise 'stock' do
        gem 'rake'
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
    Dir.mkdir("tmp/stage/#{path}") rescue nil

    write_file File.join(path, "gemspec_project.gemspec"), <<-GEMSPEC
      Gem::Specification.new do |s|
        s.name = 'gemspec_project'
        s.version = '0.1'
        s.summary = 'Awesome Gem!'
        s.authors = "Appraisal"

        s.add_development_dependency('dummy', '1.1.0')
      end
    GEMSPEC
  end
end
