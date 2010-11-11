Gem::Specification.new do |s|
    s.name        = %q{appraisal}
    s.version     = '0.1'
    s.summary     = %q{Find out how much your Ruby gems are worth}
    s.description = %q{appraisal integrates with bundler and rake to test your library against different versions of dependencies in repeatable scenarios called "appraisals."}

    s.files        = Dir['[A-Z]*', 'lib/**/*.rb', 'features/**/*']
    s.require_path = 'lib'
    s.test_files   = Dir['features/**/*']

    s.has_rdoc = false

    s.authors = ["Joe Ferris"]
    s.email   = %q{jferris@thoughtbot.com}
    s.homepage = "http://github.com/thoughtbot/appraisal"

    s.add_development_dependency('cucumber')
    s.add_development_dependency('aruba')

    s.add_runtime_dependency('rake')
    s.add_runtime_dependency('bundler')

    s.platform = Gem::Platform::RUBY
    s.rubygems_version = %q{1.2.0}
end

