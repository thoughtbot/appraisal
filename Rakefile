# frozen_string_literal: true

require "bundler/setup"
require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new do |t|
  t.pattern = "spec/**/*_spec.rb"
  t.ruby_opts = %w[-w]
  t.verbose = false
end

begin
  require "rubocop/lts"
  Rubocop::Lts.install_tasks
rescue LoadError
  task(:rubocop_gradual) do
    warn("RuboCop (Gradual) is disabled")
  end
end

desc "Default: rubocop_gradual's autocorrect and run the rspec examples"
task :default => ["rubocop_gradual:autocorrect", :spec]
