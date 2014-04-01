require 'spec_helper'

describe 'Gemfile DSL compatibility' do
  it 'supports all Bundler DSL in Gemfile' do
    build_gem 'bacon'
    build_gem 'bread'
    build_gem 'miso_soup'
    build_gem 'rice'
    build_gem 'waffle'
    build_git_gem 'egg'

    build_gemfile <<-Gemfile
      source "https://rubygems.org"
      ruby RUBY_VERSION

      git "../gems/egg" do
        gem "egg"
      end

      group :breakfast do
        gem "bacon"
      end

      platforms :ruby, :jruby do
        gem "waffle"
      end

      gem 'appraisal', path: #{PROJECT_ROOT.inspect}
    Gemfile

    build_appraisal_file <<-Appraisals
      appraise "japanese" do
        gem "rice"
        gem "miso_soup"
      end

      appraise "english" do
        gem "bread"
      end
    Appraisals

    run 'bundle install --local --binstubs'
    run 'appraisal generate'

    expect(content_of 'gemfiles/japanese.gemfile').to include <<-Gemfile.strip_heredoc
      source "https://rubygems.org"

      ruby "#{RUBY_VERSION}"

      git "../gems/egg" do
        gem "egg"
      end

      gem "appraisal", :path=>#{PROJECT_ROOT.inspect}
      gem "rice"
      gem "miso_soup"

      group :breakfast do
        gem "bacon"
      end

      platforms :ruby, :jruby do
        gem "waffle"
      end
    Gemfile

    expect(content_of 'gemfiles/english.gemfile').to include <<-Gemfile.strip_heredoc
      source "https://rubygems.org"

      ruby "#{RUBY_VERSION}"

      git "../gems/egg" do
        gem "egg"
      end

      gem "appraisal", :path=>#{PROJECT_ROOT.inspect}
      gem "bread"

      group :breakfast do
        gem "bacon"
      end

      platforms :ruby, :jruby do
        gem "waffle"
      end
    Gemfile
  end
end
