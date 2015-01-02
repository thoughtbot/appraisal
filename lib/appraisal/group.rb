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

    private

    def dependencies_list
      [@dependencies.to_s, @gemspec.to_s].
        reject(&:empty?).
        join("\n\n").
        gsub(/^/, "  ").
        strip
    end
  end
end
