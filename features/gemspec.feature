@disable-bundler
Feature: appraisals using an existing gemspec

  Background:
    Given a directory named "gemspecced"
    And the following installed dummy gems:
      | name       | version |
      | dummy_girl | 1.3.0   |
      | dummy_girl | 1.3.2   |
    When I cd to "gemspecced"
    And I write to "gemspecced.gemspec" with:
    """
    Gem::Specification.new do |s|
        s.name        = %q{gemspecced}
        s.version     = '0.1'
        s.summary     = %q{featureful!}

        s.add_development_dependency('dummy_girl', '1.3.2')
    end
    """
    And a directory named "specdir"
    And I write to "specdir/gemspecced.gemspec" with:
    """
    Gem::Specification.new do |s|
        s.name        = %q{gemspecced}
        s.version     = '0.1'
        s.summary     = %q{featureful!}

        s.add_development_dependency('dummy_girl', '1.3.0')
    end
    """
    And I write to "Appraisals" with:
    """
    appraise "stock" do
      gem "rake"
    end
    """
    When I write to "Rakefile" with:
    """
    require 'rubygems'
    require 'bundler/setup'
    require 'appraisal'
    task :version do
      require 'dummy_girl'
      puts "Loaded #{$dummy_girl_version}"
    end
    """

  Scenario: run a gem in the gemspec
    And I write to "Gemfile" with:
    """
    gemspec
    """
    When I add "appraisal" from this project as a dependency
    And I successfully run `bundle install --local`
    And I successfully run `bundle exec rake appraisal:install --trace`
    And I run `bundle exec rake appraisal version --trace`
    Then the output should contain "Loaded 1.3.2"


  Scenario: run a gem in the gemspec via path
    And I write to "Gemfile" with:
    """
    gemspec :path => './specdir'
    """
    When I add "appraisal" from this project as a dependency
    When I successfully run `bundle exec rake appraisal:install --trace`
    When I run `bundle exec rake appraisal version --trace`
    Then the output should contain "Loaded 1.3.0"

  Scenario: run a gem in the gemspec via path
    And I write to "Gemfile" with:
    """
    gemspec :path => './specdir'
    """
    When I add "appraisal" from this project as a dependency
    When I successfully run `bundle exec rake appraisal:install --trace`
    When I run `bundle exec rake appraisal version --trace`
    Then the output should contain "Loaded 1.3.0"
