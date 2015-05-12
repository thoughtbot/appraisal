require 'appraisal/dependency'
require 'appraisal/ordered_hash'

module Appraisal
  class DependencyList
    def initialize
      @dependencies = OrderedHash.new
    end

    def add(name, requirements)
      @dependencies[name] = Dependency.new(name, requirements)
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
