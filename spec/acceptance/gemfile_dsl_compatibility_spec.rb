# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Gemfile DSL compatibility" do
  it "supports all Bundler DSL in Gemfile" do
    build_gems %w[bacon orange_juice waffle]
    build_git_gem "egg"
    build_gemspec

    build_gemfile <<-GEMFILE
      source "https://rubygems.org"
      ruby RUBY_VERSION

      git "../build/egg" do
        gem "egg"
      end

      path "../build/orange_juice" do
        gem "orange_juice"
      end

      group :breakfast do
        gem "bacon"
      end

      platforms :ruby, :jruby do
        gem "waffle"
      end

      gem 'appraisal', :path => #{PROJECT_ROOT.inspect}

      gemspec
    GEMFILE

    build_appraisal_file <<-APPRAISALS
      appraise "japanese" do
        gem "rice"
        gem "miso_soup"
      end

      appraise "english" do
        gem "bread"
      end
    APPRAISALS

    run "bundle install --local"
    run "appraisal generate"

    expect(content_of("gemfiles/japanese.gemfile")).to eq <<-GEMFILE.strip_heredoc
      # This file was generated by Appraisal

      source "https://rubygems.org"

      ruby "#{RUBY_VERSION}"

      git "../../build/egg" do
        gem "egg"
      end

      path "../../build/orange_juice" do
        gem "orange_juice"
      end

      gem "appraisal", :path => #{PROJECT_ROOT.inspect}
      gem "rice"
      gem "miso_soup"

      group :breakfast do
        gem "bacon"
      end

      platforms :ruby, :jruby do
        gem "waffle"
      end

      gemspec :path => "../"
    GEMFILE

    expect(content_of("gemfiles/english.gemfile")).to eq <<-GEMFILE.strip_heredoc
      # This file was generated by Appraisal

      source "https://rubygems.org"

      ruby "#{RUBY_VERSION}"

      git "../../build/egg" do
        gem "egg"
      end

      path "../../build/orange_juice" do
        gem "orange_juice"
      end

      gem "appraisal", :path => #{PROJECT_ROOT.inspect}
      gem "bread"

      group :breakfast do
        gem "bacon"
      end

      platforms :ruby, :jruby do
        gem "waffle"
      end

      gemspec :path => "../"
    GEMFILE
  end

  it "merges gem requirements" do
    build_gem "bacon", "1.0.0"
    build_gem "bacon", "1.1.0"
    build_gem "bacon", "1.2.0"

    build_gemfile <<-GEMFILE
      source "https://rubygems.org"

      gem "appraisal", :path => #{PROJECT_ROOT.inspect}
      gem "bacon", "1.2.0"
    GEMFILE

    build_appraisal_file <<-APPRAISALS
      appraise "1.0.0" do
        gem "bacon", "1.0.0"
      end

      appraise "1.1.0" do
        gem "bacon", "1.1.0"
      end

      appraise "1.2.0" do
        gem "bacon", "1.2.0"
      end
    APPRAISALS

    run "bundle install --local"
    run "appraisal generate"

    expect(content_of("gemfiles/1.0.0.gemfile")).to include('gem "bacon", "1.0.0"')
    expect(content_of("gemfiles/1.1.0.gemfile")).to include('gem "bacon", "1.1.0"')
    expect(content_of("gemfiles/1.2.0.gemfile")).to include('gem "bacon", "1.2.0"')
  end

  it "supports gemspec in the group block" do
    build_gem "bacon", "1.0.0"
    build_gemspec

    build_gemfile <<-GEMFILE
      source "https://rubygems.org"

      gem "appraisal", :path => #{PROJECT_ROOT.inspect}

      group :plugin do
        gemspec
      end
    GEMFILE

    build_appraisal_file <<-APPRAISALS
      appraise "1.0.0" do
        gem "bacon", "1.0.0"
      end
    APPRAISALS

    run "bundle install --local"
    run "appraisal generate"

    expect(content_of("gemfiles/1.0.0.gemfile")).to eq <<-GEMFILE.strip_heredoc
      # This file was generated by Appraisal

      source "https://rubygems.org"

      gem "appraisal", :path => #{PROJECT_ROOT.inspect}
      gem "bacon", "1.0.0"

      group :plugin do
        gemspec :path => "../"
      end
    GEMFILE
  end
end
