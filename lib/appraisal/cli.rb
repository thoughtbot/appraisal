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
  end
end
