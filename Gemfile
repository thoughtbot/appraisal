source "https://rubygems.org"

gemspec

# This here to make sure appraisal works with Rails 3.0.0.
gem "thor", "~> 0.14.0"

if RUBY_VERSION < "1.9"
  eval File.read("Gemfile-1.8")
end
