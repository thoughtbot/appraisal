@disable-bundler
Feature: raise an exception when there is no Appraisal file

  Scenario: No Appraisal file
    Given a directory named "projecto"
    And the following installed dummy gems:
      | name       | version |
      | dummy_girl | 1.3.0   |
    And I cd to "projecto"
    And I write to "Gemfile" with:
    """
    gem "dummy_girl"
    """
    And I add "appraisal" from this project as a dependency
    And I write to "Rakefile" with:
    """
    require 'rubygems'
    require 'bundler/setup'
    require 'appraisal'
    """
    And I successfully run `bundle install --local`
    When I run `bundle exec rake appraisal:install --trace`
    Then the output should contain "Unable to locate 'Appraisals' file in the current directory."
