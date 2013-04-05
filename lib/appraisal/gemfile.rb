require 'appraisal/dependency'
require 'appraisal/gemspec'

module Appraisal
  # Load bundler Gemfiles and merge dependencies
  class Gemfile
    attr_reader :dependencies

    def initialize
      @sources = []
      @dependencies = []
      @gemspec = nil
    end

    def load(path)
      run(IO.read(path))
    end

    def run(definitions)
      instance_eval(definitions, __FILE__, __LINE__)
    end

    def gem(name, *requirements)
      @dependencies.reject! { |dependency| dependency.name == name }
      @dependencies << Dependency.new(name, requirements)
    end

    def group(*names)
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
      @sources.each { |source| gemfile.source(source) }
      dependencies.each do |dependency|
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
