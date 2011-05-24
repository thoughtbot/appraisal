Feature: run a rake task through several appraisals

  Background:
    Given a directory named "projecto"
    When I cd to "projecto"
    And I write to "Gemfile" with:
    """
    source "http://rubygems.org"
    gem "rake", "0.8.7"
    gem "factory_girl"
    """
    When I add "appraisal" from this project as a dependency
    And I write to "Appraisals" with:
    """
    appraise "1.3.2" do
      gem "factory_girl", "1.3.2"
    end
    appraise "1.3.0" do
      gem "factory_girl", "1.3.0"
      gem "rake", "0.9.0"
    end
    """
    When I write to "Rakefile" with:
    """
    require 'rubygems'
    require 'bundler/setup'
    require 'appraisal'
    task :version do
      require 'factory_girl'
      puts "Loaded #{Factory::VERSION}"
    end
    task :fail do
      require 'factory_girl'
      puts "Fail #{Factory::VERSION}"
      raise
    end
    task :default => :version
    """
    When I successfully run `bundle exec rake appraisal:install --trace`

  @disable-bundler
  Scenario: run a specific task with one appraisal
    When I successfully run `bundle exec rake appraisal:1.3.0 version --trace`
    Then the output should contain "Loaded 1.3.0"

  @disable-bundler
  Scenario: run a specific task with all appraisals
    When I successfully run `bundle exec rake appraisal version --trace`
    Then the output should contain "Loaded 1.3.0"
    And the output should contain "Loaded 1.3.2"
    And the output should not contain "Invoke version"

  @disable-bundler
  Scenario: run the default task with one appraisal
    When I successfully run `bundle exec rake appraisal:1.3.0 --trace`
    Then the output should contain "Loaded 1.3.0"

  @disable-bundler
  Scenario: run the default task with all appraisals
    When I successfully run `bundle exec rake appraisal --trace`
    Then the output should contain "Loaded 1.3.0"
    And the output should contain "Loaded 1.3.2"

  @disable-bundler
  Scenario: run a failing task with one appraisal
    When I run `bundle exec rake appraisal:1.3.0 fail --trace`
    Then the output should contain "Fail 1.3.0"
    And the exit status should be 1

  @disable-bundler
  Scenario: run a failing task with all appraisals
    When I run `bundle exec rake appraisal fail --trace`
    Then the output should contain "Fail 1.3.2"
    But the output should not contain "Fail 1.3.0"
    And the exit status should be 1

