module Appraisal
  # Dependency on a gem and optional version requirements
  class Group 
    attr_reader :dependencies, :name
    def initialize(name, dependencies)
      @name = name.join(', ')
      #puts dependencies.inspect
      @dependencies = dependencies.split("\n").map { |dep| "  #{dep}\n"}.join
    end

    def to_s
      "group :#{@name} do\n#{@dependencies}end"
    end
  end
end