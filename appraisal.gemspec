# frozen_string_literal: true

require_relative "lib/appraisal/version"

Gem::Specification.new do |s|
  s.name        = "appraisal"
  s.version     = Appraisal::VERSION.dup
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Joe Ferris", "Prem Sichanugrist"]
  s.email       = ["jferris@thoughtbot.com", "prem@thoughtbot.com"]
  s.homepage    = "http://github.com/thoughtbot/appraisal"
  s.summary     = "Find out what your Ruby gems are worth"
  s.description = 'Appraisal integrates with bundler and rake to test your library against different versions of dependencies in repeatable scenarios called "appraisals."'
  s.license     = "MIT"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- exe/*`.split("\n").map { |f| File.basename(f) }
  s.bindir        = "exe"

  s.required_ruby_version = ">= 2.3.0"

  s.add_dependency("rake")
  s.add_dependency("bundler")
  s.add_dependency("thor", ">= 0.14.0")
end
