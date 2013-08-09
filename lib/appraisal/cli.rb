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
      generate

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
  end
end
