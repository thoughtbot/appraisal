require 'appraisal/dependency'

module Appraisal
  class DependencyList
    def initialize
      @dependency_names = []
      @dependencies = []
    end

    def add(name, requirements)
      unless @dependency_names.include?(name)
        @dependency_names << name
        @dependencies << Dependency.new(name, requirements)
      end
    end

    def to_s
      @dependencies.map(&:to_s).join("\n")
    end
  end
end
