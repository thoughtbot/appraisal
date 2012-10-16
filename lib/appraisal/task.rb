require 'appraisal/file'
require 'rake/tasklib'

module Appraisal
  # Defines tasks for installing appraisal dependencies and running other tasks
  # for a given appraisal.
  class Task < Rake::TaskLib
    def initialize
      namespace :appraisal do
        desc "Generate a Gemfile for each appraisal"
        task :gemfiles do
          File.each do |appraisal|
            appraisal.write_gemfile
          end
        end

        desc "Resolve and install dependencies for each appraisal"
        task :install => :gemfiles do
          File.each do |appraisal|
            appraisal.install
          end
        end

        desc "Remove all generated gemfiles from gemfiles/ folder"
        task :cleanup do
          require 'fileutils'
          FileUtils.rm_f Dir['gemfiles/*.{gemfile,gemfile.lock}']
        end

        File.each do |appraisal|
          desc "Run the given task for appraisal #{appraisal.name}"
          task appraisal.name do
            Command.from_args(appraisal.gemfile_path).exec
          end
        end

        task :all do
          File.each do |appraisal|
            Command.from_args(appraisal.gemfile_path).run
          end
          exit
        end
      end

      desc "Run the given task for all appraisals"
      task :appraisal => "appraisal:all"
    end
  end
end
