source "https://rubygems.org"

gemspec

# This here to make sure appraisal works with Rails 3.0.0.
gem "thor", "~> 0.14.0"

if RUBY_VERSION < "1.9"
  eval File.read("Gemfile-1.8")
elsif RUBY_VERSION < "2.2"
  eval File.read("Gemfile-2.1")
end
