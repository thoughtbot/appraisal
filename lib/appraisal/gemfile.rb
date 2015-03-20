require 'appraisal/dependency_list'
require 'appraisal/gemspec'
require 'appraisal/git_source'
require 'appraisal/path_source'
require 'appraisal/group'
require 'appraisal/platform'
require "active_support/ordered_hash"

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
      @groups = ActiveSupport::OrderedHash.new
      @platforms = ActiveSupport::OrderedHash.new
      @git_sources = ActiveSupport::OrderedHash.new
      @path_sources = ActiveSupport::OrderedHash.new
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
        gemfile.run(
          Utils.join_parts PARTS.map { |part| send("#{part}_entry_for_dup") }
        )
      end
    end

    def gemspec(options = {})
      @gemspec = Gemspec.new(options)
    end

    private

    def source_entry
      @sources.uniq.map { |source| "source #{source.inspect}" }.join("\n")
    end

    alias_method :source_entry_for_dup, :source_entry

    def ruby_version_entry
      if @ruby_version
        "ruby #{@ruby_version.inspect}"
      end
    end

    alias_method :ruby_version_entry_for_dup, :ruby_version_entry

    [:dependencies, :gemspec].each do |method_name|
      class_eval <<-METHODS, __FILE__, __LINE__
        private

        def #{method_name}_entry
          if @#{method_name}
            @#{method_name}.to_s
          end
        end

        def #{method_name}_entry_for_dup
          if @#{method_name}
            @#{method_name}.for_dup
          end
        end
      METHODS
    end

    [:git_sources, :path_sources, :platforms, :groups].each do |method_name|
      class_eval <<-METHODS, __FILE__, __LINE__
        private

        def #{method_name}_entry
          @#{method_name}.values.map(&:to_s).join("\n\n")
        end

        def #{method_name}_entry_for_dup
          @#{method_name}.values.map(&:for_dup).join("\n\n")
        end
      METHODS
    end
  end
end
