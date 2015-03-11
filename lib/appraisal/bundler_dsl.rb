require 'appraisal/dependency_list'

module Appraisal
  class BundlerDSL
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

    def run(&block)
      instance_exec(&block)
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

    def for_dup
      Utils.join_parts PARTS.map { |part| send("#{part}_entry_for_dup") }
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

    def indent(string)
      string.strip.gsub(/^(.+)$/, '  \1')
    end
  end
end
