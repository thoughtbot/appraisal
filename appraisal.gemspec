# frozen_string_literal: true

# TODO: Switch to require_relative once support for Ruby < 2 is dropped.
# require_relative "lib/appraisal/version"

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "appraisal/version"

Gem::Specification.new do |s|
  s.name = "appraisal"
  s.version = Appraisal::VERSION.dup
  s.platform = Gem::Platform::RUBY
  s.authors = ["Joe Ferris", "Prem Sichanugrist"]
  s.email = ["jferris@thoughtbot.com", "prem@thoughtbot.com"]
  s.homepage = "http://github.com/thoughtbot/appraisal"
  s.summary = "Find out what your Ruby gems are worth"
  s.description = 'Appraisal integrates with bundler and rake to test your library against different versions of dependencies in repeatable scenarios called "appraisals."'
  s.license = "MIT"

  # specify which files should be added to the gem when it is released.
  s.files = Dir[
    # Splats (keep alphabetical)
    "lib/**/*.rb",
  ]

  # automatically included with gem package, no need to list twice (i.e. do not list in files above).
  s.extra_rdoc_files = Dir[
    # Files (keep alphabetical)
    "CONTRIBUTING.md",
    "MIT-LICENSE",
    "README.md",
    "SECURITY.md",
  ]

  # bin/ is scripts, in any available language, for development of this specific gem
  # exe/ is for ruby scripts that will ship with this gem to be used by other tools
  s.bindir = "exe"
  # files listed are relative paths from bindir above.
  s.executables = [
    "appraisal",
  ]

  s.required_ruby_version = ">= 1.8.7"

  s.add_runtime_dependency("bundler", ">= 1.17.3")  # Last version supporting Ruby 1.8.7
  s.add_runtime_dependency("rake", ">= 10")         # Last version supporting Ruby 1.8.7
  s.add_runtime_dependency("thor", ">= 0.14")       # Last version supporting Ruby 1.8.7 && Rails 3

  s.add_development_dependency("activesupport", ">= 3.2.21")
  s.add_development_dependency("rspec", "~> 3.13")
  s.add_development_dependency("rspec-pending_for", "~> 0.1", ">= 0.1.17")
end
