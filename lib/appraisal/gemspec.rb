require 'pathname'

module Appraisal
  class Gemspec
    attr_reader :options

    def initialize(options = {})
      @options = options
      @options[:path] ||= '.'
    end

    def exists?
      Dir[::File.join(@options[:path], "*.gemspec")].size > 0
    end

    def to_s
      if exists?
        "gemspec #{exported_options.inspect.gsub(/^\{|\}$/, '')}"
      end
    end

    private

    def exported_options
      # Check to see if this is an absolute path
      if @options[:path] =~ /^(?:\/|\S:)/
        @options
      else
        # Remove leading ./ from path, if any
        exported_path = ::File.join("..", @options[:path].sub(/^\.\/?/,''))
        @options.merge(:path => exported_path)
      end
    end
  end
end
