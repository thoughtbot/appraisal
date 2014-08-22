require 'appraisal/dependency'

module Appraisal
  class DependencyList
    def initialize
      @dependencies = {}
    end

    def add(name, requirements)
      @dependencies[name] = Dependency.new(name, requirements)
    end

    def to_s
      @dependencies.values.map(&:to_s).join("\n")
    end
  end
end
