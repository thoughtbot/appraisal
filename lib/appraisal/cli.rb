require 'thor'

module Appraisal
  class CLI < Thor
    desc 'generate', 'generate a gemfile for each appraisal'
    def generate
      File.each do |appraisal|
        appraisal.write_gemfile
      end
    end
  end
end
