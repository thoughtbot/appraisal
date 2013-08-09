require 'thor'
require 'fileutils'

module Appraisal
  class CLI < Thor
    default_task :install

    def self.exit_on_failure?
      true
    end

    desc '[install]', 'Resolve and install dependencies for each appraisal'
    def install
      invoke :generate

      File.each do |appraisal|
        appraisal.install
        appraisal.relativize
      end
    end

    desc 'generate', 'Generate a gemfile for each appraisal'
    def generate
      File.each do |appraisal|
        appraisal.write_gemfile
      end
    end

    desc 'clean', 'Remove all generated gemfiles and lockfiles from gemfiles folder'
    def clean
      FileUtils.rm_f Dir['gemfiles/*.{gemfile,gemfile.lock}']
    end

    # Create a subcommand for each of the appraisal
    File.each do |appraisal|
      desc "#{name} COMMAND", "Runs a command against '#{name}' appraisal"
      define_method appraisal.name do |*commands|
        Command.new(commands.join(' '), appraisal.gemfile_path).run
      end
    end
  end
end
