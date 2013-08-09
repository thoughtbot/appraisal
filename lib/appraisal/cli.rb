require 'thor'

module Appraisal
  class CLI < Thor
    default_task :generate

    desc '[generate]', 'Generate a gemfile for each appraisal'
    def generate
      File.each do |appraisal|
        appraisal.write_gemfile
      end
    end

    desc 'install', 'Resolve and install dependencies for each appraisal'
    def install
      generate

      File.each do |appraisal|
        appraisal.install
        appraisal.relativize
      end
    end
  end
end
