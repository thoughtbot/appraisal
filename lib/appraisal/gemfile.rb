require 'appraisal/dependency'
require 'appraisal/group'
require 'appraisal/gemspec'

module Appraisal
  # Load bundler Gemfiles and merge dependencies
  class Gemfile
    attr_accessor :dependencies, :sources, :groups

    def initialize
      @sources = []
      @dependencies = []
      @groups = []
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

    def group(name, &block)
      klass = self.class.new
      block.call(klass)
      @groups << Group.new(name, klass.to_s.sub("\n\n", ''))
    end

    def source(source)
      @sources << source
    end

    def to_s
      [source_entry, dependencies_entry, group_entry, gemspec_entry].join("\n\n")
    end

    def dup
      gemfile = Gemfile.new
      @groups.each { |group| gemfile.groups << group}
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

    def group_entry
      @groups.map(&:to_s).join("\n")
    end

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
