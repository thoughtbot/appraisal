require 'pathname'

module Appraisal
  class Gemspec
    attr_reader :opts
    def initialize(opts = nil)
      @opts = opts || {}
      # figure out the right path for the gemspec
      @opts[:path] ||= '.'
      @opts[:path] = ::File.expand_path(@opts[:path])
    end
    def to_s
      "gemspec(#{opts.inspect})"
    end
  end
end
