module Appraisal
  class Group
    attr_reader :dependencies, :name, :block

    def initialize(name, dependencies = {}, &block)
      @dependencies = {}
      @name = name
      @block = block
      instance_eval(&block) if block
    end

    def gem(name, *requirements)
      @dependencies[name] = Dependency.new(name, requirements)
    end


    def to_s
      [group_start_entry, dependencies_entry, group_end_entry].join("\n")
    end

    def dup
      Group.new(name, &block)
    end

    protected

    def group_start_entry
      "group #{@name.inspect} do"
    end

    def dependencies_entry
      "  " + dependencies.values.map { |dependency| dependency.to_s }.join("\n  ")
    end

    def group_end_entry
      "end"
    end

  end
end
