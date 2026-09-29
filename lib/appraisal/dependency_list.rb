# frozen_string_literal: true

require "appraisal/dependency"
require "set"

module Appraisal
  # An ordered collection of Dependency instances declared via `gem`, with
  # support for later removing a dependency by name via `remove_gem`.
  class DependencyList
    def initialize
      @dependencies = {}
      @removed_dependencies = Set.new
    end

    def add(name, requirements)
      unless @removed_dependencies.include?(name)
        @dependencies[name] = Dependency.new(name, requirements)
      end
    end

    def remove(name)
      if @removed_dependencies.add?(name)
        @dependencies.delete(name)
      end
    end

    def to_s
      @dependencies.values.map(&:to_s).join("\n")
    end

    # :nodoc:
    def for_dup
      @dependencies.values.map(&:for_dup).join("\n")
    end
  end
end
