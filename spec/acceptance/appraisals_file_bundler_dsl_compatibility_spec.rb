require "spec_helper"

RSpec.describe "Appraisals file Bundler DSL compatibility" do
  it "supports all Bundler DSL in Appraisals file" do
    build_gems %w(bagel orange_juice milk waffle coffee ham
                  sausage pancake rotten_egg mayonnaise)
    build_git_gems %w(egg croissant pain_au_chocolat omelette)

    build_gemfile <<-Gemfile
      source 'https://rubygems.org'
      git_source(:custom_git_source) { |repo| "../build/\#{repo}" }
      ruby RUBY_VERSION

      gem 'bagel'
      gem "croissant", :custom_git_source => "croissant"

      git '../build/egg' do
        gem 'egg'
      end

      path '../build/waffle' do
        gem 'waffle'
      end

      group :breakfast do
        gem 'orange_juice'
        gem "omelette", :custom_git_source => "omelette"
        gem 'rotten_egg'
      end

      platforms :ruby, :jruby do
        gem 'milk'

        group :lunch do
          gem "coffee"
        end
      end

      source "https://other-rubygems.org" do
        gem "sausage"
      end

      install_if '"-> { true }"' do
        gem 'mayonnaise'
      end

      gem 'appraisal', :path => #{PROJECT_ROOT.inspect}
    Gemfile

    build_appraisal_file <<-Appraisals
      appraise 'breakfast' do
        source 'http://some-other-source.com'
        ruby "2.3.0"

        gem 'bread'
        gem "pain_au_chocolat", :custom_git_source => "pain_au_chocolat"

        git '../build/egg' do
          gem 'porched_egg'
        end

        path '../build/waffle' do
          gem 'chocolate_waffle'
        end

        group :breakfast do
          remove_gem 'rotten_egg'
          gem 'bacon'

          platforms :rbx do
            gem "ham"
          end
        end

        platforms :ruby, :jruby do
          gem 'yoghurt'
        end

        source "https://other-rubygems.org" do
          gem "pancake"
        end

        install_if "-> { true }" do
          gem 'ketchup'
        end

        gemspec
        gemspec :path => "sitepress"
      end
    Appraisals

    run "bundle install --local"
    run "appraisal generate"

    expect(content_of "gemfiles/breakfast.gemfile").to eq <<-Gemfile.strip_heredoc
      # This file was generated by Appraisal

      source "https://rubygems.org"
      source "http://some-other-source.com"

      ruby "2.3.0"

      git "../../build/egg" do
        gem "egg"
        gem "porched_egg"
      end

      path "../../build/waffle" do
        gem "waffle"
        gem "chocolate_waffle"
      end

      gem "bagel"
      gem "croissant", :git => "../../build/croissant"
      gem "appraisal", :path => #{PROJECT_ROOT.inspect}
      gem "bread"
      gem "pain_au_chocolat", :git => "../../build/pain_au_chocolat"

      group :breakfast do
        gem "orange_juice"
        gem "omelette", :git => "../../build/omelette"
        gem "bacon"

        platforms :rbx do
          gem "ham"
        end
      end

      platforms :ruby, :jruby do
        gem "milk"
        gem "yoghurt"

        group :lunch do
          gem "coffee"
        end
      end

      source "https://other-rubygems.org" do
        gem "sausage"
        gem "pancake"
      end

      install_if -> { true } do
        gem "mayonnaise"
        gem "ketchup"
      end

      gemspec :path => "../"
      gemspec :path => "../sitepress"
    Gemfile
  end

  it 'supports ruby file: ".ruby-version" DSL' do
    build_gemfile <<-Gemfile
      source 'https://rubygems.org'

      ruby RUBY_VERSION

      gem 'appraisal', :path => #{PROJECT_ROOT.inspect}
    Gemfile

    build_appraisal_file <<-Appraisals
      appraise 'ruby-version' do
        ruby file: ".ruby-version"
      end
    Appraisals

    run "bundle install --local"
    run "appraisal generate"

    expect(content_of "gemfiles/ruby_version.gemfile").to eq <<-Gemfile.strip_heredoc
      # This file was generated by Appraisal

      source "https://rubygems.org"

      ruby({:file=>".ruby-version"})

      gem "appraisal", :path => #{PROJECT_ROOT.inspect}
    Gemfile
  end
end
