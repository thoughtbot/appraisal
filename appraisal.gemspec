# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "appraisal/version"

Gem::Specification.new do |s|
  s.name        = %q{appraisal}
  s.version     = Appraisal::VERSION.dup
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Joe Ferris"]
  s.email       = %q{jferris@thoughtbot.com}
  s.homepage    = "http://github.com/thoughtbot/appraisal"
  s.summary     = %q{Find out what your Ruby gems are worth}
  s.description = %q{Appraisal integrates with bundler and rake to test your library against different versions of dependencies in repeatable scenarios called "appraisals."}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency('rake')
  s.add_runtime_dependency('bundler')

  s.add_development_dependency('cucumber', '~> 1.0')
  s.add_development_dependency('rspec', '~> 2.6')
  s.add_development_dependency('aruba', '~> 0.4.2')
end
