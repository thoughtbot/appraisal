require 'appraisal/dependency_list'
require 'appraisal/gemspec'
require 'appraisal/git_source'
require 'appraisal/path_source'
require 'appraisal/group'
require 'appraisal/platform'

module Appraisal
  # Load bundler Gemfiles and merge dependencies
  class Gemfile
    attr_reader :dependencies

    def initialize
      @sources = []
      @ruby_version = nil
      @dependencies = DependencyList.new
      @gemspec = nil
      @groups = {}
      @platforms = {}
      @git_sources = {}
      @path_sources = {}
    end

    def load(path)
      run(IO.read(path))
    end

    def run(definitions)
      instance_eval(definitions, __FILE__, __LINE__) if definitions
    end

    def gem(name, *requirements)
      @dependencies.add(name, requirements)
    end

    def group(*names, &block)
      @groups[names] ||= Group.new(names)
      @groups[names].run(&block)
    end

    alias_method :groups, :group

    def platforms(*names, &block)
      @platforms[names] ||= Platform.new(names)
      @platforms[names].run(&block)
    end

    def source(source)
      @sources << source
    end

    def ruby(ruby_version)
      @ruby_version = ruby_version
    end

    def git(source, options = {}, &block)
      @git_sources[source] ||= GitSource.new(source, options)
      @git_sources[source].run(&block)
    end

    def path(source, options = {}, &block)
      @path_sources[source] ||= PathSource.new(source, options)
      @path_sources[source].run(&block)
    end

    def to_s
      [source_entry,
        ruby_version_entry,
        git_sources_entry,
        path_sources_entry,
        dependencies_entry,
        groups_entry,
        platforms_entry,
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
      @git_sources.values.map(&:to_s).join("\n\n")
    end

    def path_sources_entry
      @path_sources.values.map(&:to_s).join("\n\n")
    end

    def dependencies_entry
      @dependencies.to_s
    end

    def groups_entry
      @groups.values.map(&:to_s).join("\n\n")
    end

    def platforms_entry
      @platforms.values.map(&:to_s).join("\n\n")
    end

    def gemspec_entry
      @gemspec.to_s
    end
  end
end
