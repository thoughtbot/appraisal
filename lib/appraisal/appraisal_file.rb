# frozen_string_literal: true

require "appraisal/appraisal"
require "appraisal/customize"
require "appraisal/errors"
require "appraisal/gemfile"

module Appraisal
  # Loads and parses Appraisals file
  class AppraisalFile
    attr_reader :appraisals, :gemfile

    def self.each(&block)
      new.each(&block)
    end

    def initialize
      @appraisals = []
      @gemfile = Gemfile.new
      @gemfile.load(ENV["BUNDLE_GEMFILE"] || "Gemfile")

      raise AppraisalsNotFound unless File.exist?(path)

      run(File.read(path))
    end

    def each(&block)
      appraisals.each(&block)
    end

    def appraise(name, &block)
      appraisal = Appraisal.new(name, gemfile)
      appraisal.instance_eval(&block)
      @appraisals << appraisal
    end

    def customize_gemfiles(&_block)
      args = yield
      Customize.new(args)
    end

    private

    def run(definitions)
      instance_eval(definitions, __FILE__, __LINE__)
    end

    def path
      "Appraisals"
    end
  end
end
