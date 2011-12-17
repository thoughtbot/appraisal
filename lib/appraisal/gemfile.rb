require 'appraisal/dependency'
require 'appraisal/gemspec'

module Appraisal
  # Load bundler Gemfiles and merge dependencies
  class Gemfile
    attr_accessor :dependencies, :sources

    def initialize
      @sources = []
      @dependencies = []
    end

    def load(path)
      run(IO.read(path))
    end

    def run(definitions)
      instance_eval(definitions, __FILE__, __LINE__)
    end

    def gem(name, *requirements)
      reject_dependency!(name)
      @dependencies << Dependency.new(name, requirements)
    end

    def reject_dependency!(name)
      @dependencies.reject! { |dependency| dependency.name == name }
    end

    def group(name)
      # ignore the group
    end

    def source(source)
      @sources << source
    end

    def to_s
      [source_entry, dependencies_entry, gemspec_entry].join("\n\n")
    end

    def dup
      gemfile = Gemfile.new
      @sources.each { |source| gemfile.source source }
      dependencies.each do |dep|
        gemfile.reject_dependency!(dep.name)
        # we want to actualy dup the dependency here 
        # so that it maintains its rewrite state
        gemfile.dependencies << dep.dup
      end
      gemfile.gemspec(@gemspec.options) if @gemspec
      gemfile
    end

    def gemspec(options = {})
      @gemspec = Gemspec.new(options)
    end

    protected

    def source_entry
      @sources.map { |source| "source #{source.inspect}" }.join("\n")
    end

    def dependencies_entry
      dependencies.map { |dependency| dependency.to_s }.join("\n")
    end

    def gemspec_entry
      @gemspec.to_s
    end
  end
end
