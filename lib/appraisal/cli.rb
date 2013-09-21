require 'thor'
require 'fileutils'

module Appraisal
  class CLI < Thor
    default_task :install

    # Override help command to print out usage
    def self.help(shell, subcommand = false)
      shell.say strip_heredoc(<<-help)
        Appraisal: Find out what your Ruby gems are worth.

        Usage:
          appraisal [APPRAISAL_NAME] EXTERNAL_COMMAND

          If APPRAISAL_NAME is given, only run that EXTERNAL_COMMAND against the given
          appraisal, otherwise it runs the EXTERNAL_COMMAND against all appraisals.

        Available Appraisal(s):
      help

      File.each do |appraisal|
        shell.say "  - #{appraisal.name}"
      end

      shell.say

      super
    end

    def self.exit_on_failure?
      true
    end

    desc 'install', 'Resolve and install dependencies for each appraisal'
    method_option 'jobs', aliases: 'j', type: :numeric, default: 1, banner: 'SIZE',
      desc: 'Install gems in parallel using the given number of workers.'
    def install
      invoke :generate, [], {}

      File.each do |appraisal|
        appraisal.install(options[:jobs])
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

    desc 'update [LIST_OF_GEMS]', 'Remove all generated gemfiles and lockfiles, resolve, and install dependencies again'
    def update(*gems)
      invoke :generate, []

      File.each do |appraisal|
        appraisal.update(gems)
      end
    end

    private

    def method_missing(name, *args, &block)
      matching_appraisal = File.new.appraisals.detect { |appraisal| appraisal.name == name.to_s }

      if matching_appraisal
        Command.new(args.join(' '), matching_appraisal.gemfile_path).run
      else
        File.each do |appraisal|
          Command.new(ARGV.join(' '), appraisal.gemfile_path).run
        end
      end
    end

    def self.strip_heredoc(string)
      indent = string.scan(/^[ \t]*(?=\S)/).min.size || 0
      string.gsub(/^[ \t]{#{indent}}/, '')
    end
  end
end
