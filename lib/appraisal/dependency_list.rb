# frozen_string_literal: true

require "appraisal/dependency"
require "appraisal/ordered_hash"
require "set"

module Appraisal
  class DependencyList
    def initialize
      @dependencies = OrderedHash.new
      @removed_dependencies = Set.new
    end

    def add(name, requirements)
      return if @removed_dependencies.include?(name)

      @dependencies[name] = Dependency.new(name, requirements)
    end

    def remove(name)
      return unless @removed_dependencies.add?(name)

      @dependencies.delete(name)
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
