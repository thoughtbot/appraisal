require 'appraisal/dependency_list'

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
      "platforms #{@platform_names.map(&:inspect).join(', ')} do\n" +
        @dependencies.to_s.strip.gsub(/^/, '  ') + "\nend"
    end
  end
end
