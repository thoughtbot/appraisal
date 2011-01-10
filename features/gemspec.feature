Feature: appraisals using an existing gemspec

Background:
  Given a directory named "gemspecced"
  When I cd to "gemspecced"
  And I write to "gemspecced.gemspec" with:
  """
  Gem::Specification.new do |s|
      s.name        = %q{gemspecced}
      s.version     = '0.1'
      s.summary     = %q{featureful!}

      s.add_runtime_dependency('mocha')
      s.add_development_dependency('factory_girl', '1.3.2')
  end
  """
  And a directory named "specdir"
  And I write to "specdir/gemspecced.gemspec" with:
  """
  Gem::Specification.new do |s|
      s.name        = %q{gemspecced}
      s.version     = '0.1'
      s.summary     = %q{featureful!}

      s.add_runtime_dependency('mocha')
      s.add_development_dependency('factory_girl', '1.3.0')
  end
  """
  And I write to "Appraisals" with:
  """
  appraise "stock" do
    gem "shoulda", "2.11.3"
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
  """

@disable-bundler
Scenario: run a gem in the gemspec
  And I write to "Gemfile" with:
  """
  source "http://rubygems.org"
  gemspec
  """
  When I add "appraisal" from this project as a dependency
  When I successfully run "rake appraisal:install --trace"
  When I run "rake appraisal version --trace"
  Then the output should contain "Loaded 1.3.2"


@disable-bundler
Scenario: run a gem in the gemspec via path
  And I write to "Gemfile" with:
  """
  source "http://rubygems.org"
  gemspec :path => './specdir'
  """
  When I add "appraisal" from this project as a dependency
  When I successfully run "rake appraisal:install --trace"
  When I run "rake appraisal version --trace"
  Then the output should contain "Loaded 1.3.0"

