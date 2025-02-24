# frozen_string_literal: true

require "appraisal/dependency_list"
require "appraisal/ordered_hash"

module Appraisal
  class BundlerDSL
    attr_reader :dependencies

    PARTS = %w[
      source
      ruby_version
      gits
      paths
      dependencies
      groups
      platforms
      source_blocks
      install_if
      gemspec
      eval_gemfile
    ]

    def initialize
      @sources = []
      @ruby_version = nil
      @dependencies = DependencyList.new
      @gemspecs = []
      @groups = OrderedHash.new
      @platforms = OrderedHash.new
      @gits = OrderedHash.new
      @paths = OrderedHash.new
      @source_blocks = OrderedHash.new
      @git_sources = {}
      @install_if = {}
      @eval_gemfile = []
    end

    def run(&block)
      instance_exec(&block)
    end

    def eval_gemfile(path, contents = nil)
      @eval_gemfile << [path, contents]
    end

    def gem(name, *requirements)
      @dependencies.add(name, substitute_git_source(requirements))
    end

    def remove_gem(name)
      @dependencies.remove(name)
    end

    def group(*names, &block)
      @groups[names] ||=
        Group.new(names).tap { |g| g.git_sources = @git_sources.dup }
      @groups[names].run(&block)
    end

    def install_if(condition, &block)
      @install_if[condition] ||=
        Conditional.new(condition).tap { |g| g.git_sources = @git_sources.dup }
      @install_if[condition].run(&block)
    end

    def platforms(*names, &block)
      @platforms[names] ||=
        Platform.new(names).tap { |g| g.git_sources = @git_sources.dup }
      @platforms[names].run(&block)
    end

    alias_method :platform, :platforms

    def source(source, &block)
      if block_given?
        @source_blocks[source] ||=
          Source.new(source).tap { |g| g.git_sources = @git_sources.dup }
        @source_blocks[source].run(&block)
      else
        @sources << source
      end
    end

    def ruby(ruby_version)
      @ruby_version = ruby_version
    end

    def git(source, options = {}, &block)
      @gits[source] ||=
        Git.new(source, options).tap { |g| g.git_sources = @git_sources.dup }
      @gits[source].run(&block)
    end

    def path(source, options = {}, &block)
      @paths[source] ||=
        Path.new(source, options).tap { |g| g.git_sources = @git_sources.dup }
      @paths[source].run(&block)
    end

    def to_s
      Utils.join_parts(PARTS.map { |part| send(:"#{part}_entry") })
    end

    def for_dup
      Utils.join_parts(PARTS.map { |part| send(:"#{part}_entry_for_dup") })
    end

    def gemspec(options = {})
      @gemspecs << Gemspec.new(options)
    end

    def git_source(source, &block)
      @git_sources[source] = block
    end

    protected

    attr_writer :git_sources

    private

    def eval_gemfile_entry
      @eval_gemfile.map { |(p, c)| "eval_gemfile(#{p.inspect}#{", #{c.inspect}" if c})" } * "\n\n"
    end

    alias_method :eval_gemfile_entry_for_dup, :eval_gemfile_entry

    def source_entry
      @sources.uniq.map { |source| "source #{source.inspect}" }.join("\n")
    end

    alias_method :source_entry_for_dup, :source_entry

    def ruby_version_entry
      return unless @ruby_version

      case @ruby_version
      when String then "ruby #{@ruby_version.inspect}"
      else "ruby(#{Utils.format_string(@ruby_version)})"
      end
    end

    alias_method :ruby_version_entry_for_dup, :ruby_version_entry

    def gemspec_entry
      @gemspecs.map(&:to_s).join("\n")
    end

    def gemspec_entry_for_dup
      @gemspecs.map(&:for_dup).join("\n")
    end

    def dependencies_entry
      @dependencies.to_s
    end

    def dependencies_entry_for_dup
      @dependencies.for_dup
    end

    [:gits, :paths, :platforms, :groups, :source_blocks, :install_if].each do |method_name|
      class_eval <<-METHODS, __FILE__, __LINE__ + 1
        private

        def #{method_name}_entry
          @#{method_name}.values.map(&:to_s).join("\n\n")
        end

        def #{method_name}_entry_for_dup
          @#{method_name}.values.map(&:for_dup).join("\n\n")
        end
      METHODS
    end

    def indent(string)
      indent_by = ENV.fetch("APPRAISAL_INDENTER", "lookaround")
      if indent_by == "lookaround"
        # Default indenter for Appraisal v3
        # Uses a "look-around" of the "look-behind" variety to indent lines that are more than just empty space.
        # In other words, retain existing indentation, and indent the line again, but not on empty lines.
        string.
          # NOTES:
          #   (?![\r\n]) - Negative Look Behind which requires that the following pattern,
          #                which is (\s*) in this case, *not* be followed by a new line character
          #   (\s*) - Captures whitespace at beginning of the line
          #   Learn more here: https://learnbyexample.github.io/Ruby_Regexp/lookarounds.html
          gsub(/^(?![\r\n])(\s*)/, '  \0').
          rstrip
      elsif indent_by == "capture"
        # Original indentation regex for Appraisal < v3
        string.gsub(/^(.+)$/, '  \1').rstrip
      else
        string
      end
    end

    def substitute_git_source(requirements)
      requirements.each do |requirement|
        next unless requirement.is_a?(Hash)

        (requirement.keys & @git_sources.keys).each do |matching_source|
          value = requirement.delete(matching_source)
          requirement[:git] = @git_sources[matching_source].call(value)
        end
      end
    end
  end
end
