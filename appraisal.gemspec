Gem::Specification.new do |s|
  s.name        = %q{appraisal}
  s.version     = '0.3.7'
  s.summary     = %q{Find out what your Ruby gems are worth}
  s.description = %q{Appraisal integrates with bundler and rake to test your library against different versions of dependencies in repeatable scenarios called "appraisals."}

  s.files        = Dir['[A-Z]*', 'lib/**/*.rb', 'features/**/*']
  s.require_path = 'lib'
  s.test_files   = Dir['features/**/*']

  s.authors = ["Joe Ferris"]
  s.email   = %q{jferris@thoughtbot.com}
  s.homepage = "http://github.com/thoughtbot/appraisal"

  s.add_development_dependency('cucumber', '~> 1.0')
  s.add_development_dependency('rspec', '~> 2.6')
  s.add_development_dependency('aruba', '~> 0.4.2')
  
  s.add_runtime_dependency('rake')
  s.add_runtime_dependency('bundler')

  s.platform = Gem::Platform::RUBY
  s.rubygems_version = %q{1.2.0}
end
