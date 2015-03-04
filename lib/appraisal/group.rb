require 'appraisal/dependency_list'
require 'appraisal/utils'

module Appraisal
  class Group
    def initialize(group_names)
      @dependencies = DependencyList.new
      @group_names = group_names
      @gemspec = nil
    end

    def run(&block)
      instance_exec(&block)
    end

    def gem(name, *requirements)
      @dependencies.add(name, requirements)
    end

    def gemspec(options = {})
      @gemspec = Gemspec.new(options)
    end

    def to_s
      formatted_output dependencies_list
    end

    # :nodoc:
    def for_dup
      formatted_output dependencies_list_for_dup
    end

    private

    def dependencies_list
      Utils.join_parts([
        dependencies_entry,
        gemspec_entry
      ]).gsub(/^/, "  ")
    end

    def dependencies_list_for_dup
      Utils.join_parts([
        dependencies_entry,
        gemspec_entry_for_dup
      ]).gsub(/^/, "  ")
    end

    def formatted_output(output_dependencies)
      <<-OUTPUT.strip
group #{Utils.format_arguments(@group_names)} do
#{output_dependencies}
end
      OUTPUT
    end

    def dependencies_entry
      @dependencies.to_s
    end

    def gemspec_entry
      @gemspec.to_s
    end

    def gemspec_entry_for_dup
      if @gemspec
        @gemspec.for_dup
      end
    end
  end
end
