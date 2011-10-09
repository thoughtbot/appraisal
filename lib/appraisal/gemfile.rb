require 'appraisal/dependency'
require 'appraisal/gemspec'

module Appraisal
  # Load bundler Gemfiles and merge dependencies
  class Gemfile
    attr_reader :dependencies

    def initialize
      @dependencies = {}
    end

    def load(path)
      run(IO.read(path))
    end

    def run(definitions)
      instance_eval(definitions, __FILE__, __LINE__)
    end

    def gem(name, *requirements)
      @dependencies[name] = Dependency.new(name, requirements)
    end

    def group(name)
      # ignore the group
    end

    def source(source)
      @source = source
    end

    def to_s
      [source_entry, dependencies_entry, gemspec_entry].join("\n\n")
    end

    def dup
      gemfile = Gemfile.new
      gemfile.source @source
      dependencies.values.each do |dependency|
        gemfile.gem(dependency.name, *dependency.requirements)
      end
      gemfile.gemspec(@gemspec.options) if @gemspec
      gemfile
    end

    def gemspec(options = {})
      @gemspec = Gemspec.new(options)
    end

    protected

    def source_entry
      %(source #{@source.inspect})
    end

    def dependencies_entry
      dependencies.values.map { |dependency| dependency.to_s }.join("\n")
    end

    def gemspec_entry
      @gemspec.to_s
    end
  end
end
