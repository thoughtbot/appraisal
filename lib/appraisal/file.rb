require 'appraisal/appraisal'
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
      @gemfile.load('Gemfile')
      run(IO.read(path)) if ::File.exists?(path)
    end

    def each(&block)
      appraisals.each(&block)
    end

    def appraise(name, &block)
      @appraisals << Appraisal.new(name, gemfile).tap do |appraisal|
        appraisal.instance_eval(&block)
      end
    end

    private

    def run(definitions)
      instance_eval definitions, __FILE__, __LINE__
    end

    def path
      'Appraisals'
    end
  end
end

