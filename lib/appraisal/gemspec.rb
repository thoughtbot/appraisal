require 'pathname'

module Appraisal
  class Gemspec
    attr_reader :options

    def initialize(options = {})
      @options = options
      @options[:path] ||= '.'
    end

    def to_s
      "gemspec #{exported_options.inspect.gsub(/^\{|\}$/, '')}"
    end

    private

    def exported_options
      # Check to see if this is an absolute path
      if @options[:path] =~ /^(?:\/|\S:)/ || @options[:path] == '../'
        @options
      else
        # Remove leading ./ from path, if any
        cleaned_path = @options[:path].gsub(/(^|\/)\.\/?/, '\1')
        exported_path = ::File.join("..", cleaned_path)
        @options.merge(:path => exported_path)
      end
    end
  end
end
