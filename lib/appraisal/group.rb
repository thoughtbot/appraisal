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
      <<-OUTPUT.strip
group #{Utils.format_arguments(@group_names)} do
#{dependencies_list}
end
      OUTPUT
    end

    # :nodoc:
    def to_raw_s
      <<-OUTPUT.strip
group #{Utils.format_arguments(@group_names)} do
#{raw_dependencies_list}
end
      OUTPUT
    end

    private

    def dependencies_list
      Utils.join_parts([dependencies_entry, gemspec_entry]).gsub(/^/, "  ")
    end

    def raw_dependencies_list
      Utils.join_parts([dependencies_entry, raw_gemspec_entry]).gsub(/^/, "  ")
    end

    def dependencies_entry
      @dependencies.to_s
    end

    def gemspec_entry
      @gemspec.to_s
    end

    def raw_gemspec_entry
      if @gemspec
        @gemspec.to_raw_s
      end
    end
  end
end
