require 'appraisal/dependency_list'
require 'appraisal/utils'

module Appraisal
  class PathSource
    def initialize(source, options = {})
      @dependencies = DependencyList.new
      @source = source
      @options = options
    end

    def gem(name, *requirements)
      @dependencies.add(name, requirements)
    end

    def run(&block)
      instance_exec(&block)
    end

    def to_s
      dependencies = @dependencies.to_s.strip.gsub(/^/, '  ')

      if @options.empty?
        "path #{Utils.prefix_path(@source).inspect} do\n#{dependencies}\nend"
      else
        "path #{Utils.prefix_path(@source).inspect}, #{Utils.format_string(@options)} do\n" +
          "#{dependencies}\nend"
      end
    end

    # :nodoc:
    def for_dup
      dependencies = @dependencies.for_dup.strip.gsub(/^/, '  ')

      if @options.empty?
        "path #{@source.inspect} do\n#{dependencies}\nend"
      else
        "path #{@source.inspect}, #{Utils.format_string(@options)} do\n" +
          "#{dependencies}\nend"
      end
    end
  end
end
