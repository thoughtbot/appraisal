require 'pathname'

module Appraisal
  class Gemspec
    attr_reader :options

    def initialize(options = {})
      @options = options

      # figure out the right path for the gemspec
      @options[:path] ||= '.'
      @options[:path] = ::File.expand_path(@options[:path])
    end

    def exists?
      Dir[::File.join(@options[:path], "*.gemspec")].size > 0
    end

    def to_s
      "gemspec #{@options.inspect.gsub(/^\{|\}$/, '')}" if exists?
    end
  end
end
