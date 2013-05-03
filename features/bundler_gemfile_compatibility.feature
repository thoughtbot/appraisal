@disable-bundler
Feature: Bundler Gemfile Compatibility

  Scenario: Parsing Gemfile
    Given the following installed dummy gems:
      | name      | version |
      | bacon     | 1.0.0   |
      | bread     | 1.0.0   |
      | miso_soup | 1.0.0   |
      | rice      | 1.0.0   |
    And a git repository exists for gem "egg" with version "0.1.0"
    And I write to "Gemfile" with:
    """
    source "https://rubygems.org"
    ruby RUBY_VERSION

    git "./egg" do
      gem "egg"
    end

    group :breakfast do
      gem "bacon"
    end
    """
    And I add "appraisal" from this project as a dependency
    And I write to "Appraisals" with:
    """
    appraise "japanese" do
      gem "rice"
      gem "miso_soup"
    end

    appraise "english" do
      gem "bread"
    end
    """
    And I write to "Rakefile" with:
    """
    require 'rubygems'
    require 'bundler/setup'
    require 'appraisal'
    """
    When I successfully run `bundle install --local`
    And I successfully run `bundle exec rake appraisal:gemfiles --trace`
    Then the file "gemfiles/japanese.gemfile" should contain:
    """
    source "https://rubygems.org"
    """
    And the file "gemfiles/japanese.gemfile" should contain a correct ruby directive
    And the file "gemfiles/japanese.gemfile" should contain:
    """
    gem "rice"
    gem "miso_soup"
    """
    And the file "gemfiles/japanese.gemfile" should contain:
    """
    git "./egg" do
      gem "egg"
    end
    """
    And the file "gemfiles/japanese.gemfile" should contain:
    """
    group :breakfast do
      gem "bacon"
    end
    """
    And the file "gemfiles/english.gemfile" should contain:
    """
    gem "bread"
    """
