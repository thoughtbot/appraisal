require 'appraisal/dependency'
require 'appraisal/gemspec'
require 'appraisal/group'

module Appraisal
  # Load bundler Gemfiles and merge dependencies
  class Gemfile
    attr_reader :dependencies, :groups

    def initialize
      @dependencies = {}
      @groups = {}
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

    def group(name, &block)
      @groups[name] = Group.new(name, &block)
    end

    def source(source)
      @source = source
    end

    def to_s
      [source_entry, dependencies_entry, groups_entries, gemspec_entry].join("\n\n")
    end

    def dup
      gemfile = Gemfile.new
      gemfile.source @source
      dependencies.values.each do |dependency|
        gemfile.gem(dependency.name, *dependency.requirements)
      end
      groups.values.each do |group|
        gemfile.group(group.name, &group.block)
      end
      gemfile.gemspec(@gemspec.options) if @gemspec
      gemfile
    end

    def gemspec(options = {})
      @gemspec = Gemspec.new(options)
    end

    protected

    def source_entry
      %(source "#{@source}")
    end

    def dependencies_entry
      dependencies.values.map { |dependency| dependency.to_s }.join("\n")
    end

    def groups_entries
      groups.values.map {|group| group.to_s }.join("\n\n")
    end

    def gemspec_entry
      @gemspec.to_s
    end
  end
end
