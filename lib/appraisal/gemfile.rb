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

    PARTS = %w(source ruby_version git_sources path_sources dependencies groups
      platforms gemspec)

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

    # :nodoc:
    def groups(*names, &block)
      $stderr.puts <<-WARNING.gsub(/\n\s+/, " ").strip
        Warning: `#groups` is deprecated and will be removed in 2.0.0.
        Please use `#group` instead.
      WARNING

      group(*names, &block)
    end

    def platforms(*names, &block)
      @platforms[names] ||= Platform.new(names)
      @platforms[names].run(&block)
    end

    alias_method :platform, :platforms

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
      Utils.join_parts PARTS.map { |part| send("#{part}_entry") }
    end

    def dup
      Gemfile.new.tap do |gemfile|
        gemfile.run(to_raw_s)
      end
    end

    def gemspec(options = {})
      @gemspec = Gemspec.new(options)
    end

    def to_raw_s
      Utils.join_parts PARTS.map { |part| send("raw_#{part}_entry") }
    end

    private

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

    def platforms_entry
      @platforms.values.map(&:to_s).join("\n\n")
    end

    (PARTS - ["groups", "gemspec"]).each do |method_name|
      alias_method "raw_#{method_name}_entry", "#{method_name}_entry"
    end

    def groups_entry
      @groups.values.map(&:to_s).join("\n\n")
    end

    def raw_groups_entry
      @groups.values.map(&:to_raw_s).join("\n\n")
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
