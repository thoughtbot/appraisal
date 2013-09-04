require 'appraisal/appraisal'
require 'appraisal/exceptions'
require 'appraisal/gemfile'

module Appraisal
  # Loads and parses Appraisal files
  class File
    attr_reader :appraisals, :gemfile

    def self.each(&block)
      new.each(&block)
    end

    def initialize
      @appraisals = []
      @gemfile = Gemfile.new
      @gemfile.load(ENV['BUNDLE_GEMFILE'] || 'Gemfile')
      ::File.exists?(path) ? run(IO.read(path)) : fail(AppraisalsFileNotFound)
    end

    def each(&block)
      appraisals.each(&block)
    end

    def appraise(name, &block)
      appraisal = Appraisal.new(name, gemfile)
      appraisal.instance_eval(&block)
      @appraisals << appraisal
    end

    private

    def run(definitions)
      instance_eval(definitions, __FILE__, __LINE__)
    end

    def path
      'Appraisals'
    end
  end
end
