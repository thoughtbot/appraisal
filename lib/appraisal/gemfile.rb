require 'appraisal/dependency'
require 'appraisal/gemspec'

module Appraisal
  # Load bundler Gemfiles and merge dependencies
  class Gemfile
    attr_reader :dependencies

    def initialize
      @sources = []
      @ruby_version = nil
      @dependencies = []
      @gemspec = nil
      @groups = []
      @git_sources = []
    end

    def load(path)
      run(IO.read(path))
    end

    def run(definitions)
      instance_eval(definitions, __FILE__, __LINE__) if definitions
    end

    def gem(name, *requirements)
      @dependencies.reject! { |dependency| dependency.name == name }
      @dependencies << Dependency.new(name, requirements)
    end

    def group(*names, &block)
      require 'appraisal/group'

      group = Group.new(names)
      group.run(&block)
      @groups << group
    end

    def source(source)
      @sources << source
    end

    def ruby(ruby_version)
      @ruby_version = ruby_version
    end

    def git(source, options = {}, &block)
      require 'appraisal/git_source'

      git_source = GitSource.new(source, options)
      git_source.run(&block)
      @git_sources << git_source
    end

    def to_s
      [source_entry, ruby_version_entry, git_sources_entry, dependencies_entry, groups_entry,
        gemspec_entry].reject{ |s| s.nil? || s.empty? }.join("\n\n").strip
    end

    def dup
      gemfile = Gemfile.new
      gemfile.run(to_s)
      gemfile
    end

    def gemspec(options = {})
      @gemspec = Gemspec.new(options)
    end

    protected

    def source_entry
      @sources.map { |source| "source #{source.inspect}" }.join("\n")
    end

    def ruby_version_entry
      if @ruby_version
        "ruby #{@ruby_version.inspect}"
      end
    end

    def git_sources_entry
      @git_sources.map(&:to_s).join("\n\n")
    end

    def dependencies_entry
      dependencies.map(&:to_s).join("\n")
    end

    def groups_entry
      @groups.map(&:to_s).join("\n\n")
    end

    def gemspec_entry
      @gemspec.to_s
    end
  end
end
