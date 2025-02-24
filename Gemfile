source "https://rubygems.org"

gemspec

# For Ruby version specific dependencies
ruby_version = Gem::Version.new(RUBY_VERSION)

platform :mri do
  # Debugging - Ensure ENV["DEBUG"] == "true" to use debuggers within spec suite
  if ruby_version < Gem::Version.new("2.7")
    # Use byebug in code
    gem "byebug", ">= 11"
  else
    # Use binding.break, binding.b, or debugger in code
    gem "debug", ">= 1.0.0"
  end

  # Dev Console - Binding.pry - Irb replacement
  gem "pry", "~> 0.14"                     # ruby >= 2.0
end

# This here to make sure appraisal works with Rails 3.0.0.
gem "thor", "~> 0.14.0"

if ruby_version < Gem::Version.new("1.9")
  eval File.read("Gemfile-1.8")
elsif ruby_version < Gem::Version.new("2.1")
  eval File.read("Gemfile-2.0")
elsif ruby_version < Gem::Version.new("2.2")
  eval File.read("Gemfile-2.1")
elsif ruby_version < Gem::Version.new("2.7")
  # Std Lib extractions
  gem "benchmark", "~> 0.4" # Removed from Std Lib in Ruby 3.5
else
  # Ruby >= 2.7 we can run style / lint checks via rubocop-gradual with rubocop-lts rules for Ruby 1.8+.
  # This means we can develop on modern Ruby but remain compatible with ancient Ruby.
  # TODO: Replace individual style gems below with modular gemfile, once eval_gemfile support is added to appraisal.
  # eval_gemfile "gemfiles/modular/style.gemfile"
  # We run rubocop on the latest version of Ruby,
  #   but in support of the oldest supported version of Ruby
  gem "rubocop-lts", "~> 0.1", ">= 0.1.1" # Style and Linting support for Ruby >= 1.8
  gem "rubocop-packaging", "~> 0.5", ">= 0.5.2"
  gem "rubocop-rspec", "~> 3.2"
  gem "standard", ">= 1.35.1", "!= 1.41.1", "!= 1.42.0"

  # Std Lib extractions
  gem "benchmark", "~> 0.4" # Removed from Std Lib in Ruby 3.5
end
