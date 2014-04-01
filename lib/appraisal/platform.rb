require 'appraisal/dependency_list'
require 'appraisal/utils'

module Appraisal
  class Platform
    def initialize(platform_names)
      @dependencies = DependencyList.new
      @platform_names = platform_names
    end

    def gem(name, *requirements)
      @dependencies.add(name, requirements)
    end

    def run(&block)
      instance_exec(&block)
    end

    def to_s
      "platforms #{Utils.format_arguments(@platform_names)} do\n" +
        @dependencies.to_s.strip.gsub(/^/, '  ') +
        "\nend"
    end
  end
end
