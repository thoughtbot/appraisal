require 'appraisal/dependency_list'
require 'appraisal/utils'

module Appraisal
  class Group
    def initialize(group_names)
      @dependencies = DependencyList.new
      @group_names = group_names
    end

    def run(&block)
      instance_exec(&block)
    end

    def gem(name, *requirements)
      @dependencies.add(name, requirements)
    end

    def to_s
      "group #{Utils.format_arguments(@group_names)} do\n" +
        @dependencies.to_s.strip.gsub(/^/, '  ') + "\nend"
    end
  end
end
