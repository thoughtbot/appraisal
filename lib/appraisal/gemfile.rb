require 'appraisal/dependency'
require 'appraisal/gemspec'

module Appraisal
  # Load bundler Gemfiles and merge dependencies
  class Gemfile
    attr_reader :dependencies, :spec

    def initialize
      @dependencies = {}
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

    def source(source)
      @source = source
    end

    def to_s
      %{source "#{@source}"\n} <<
        dependencies.values.map { |dependency| dependency.to_s }.join("\n") <<
        "\n" << spec.to_s
    end

    def dup
      Gemfile.new.tap do |gemfile|
        gemfile.source @source
        dependencies.values.each do |dependency|
          gemfile.gem(dependency.name, *dependency.requirements)
        end
        gemfile.gemspec(spec.opts)
      end
    end

    def gemspec(opts = nil)
      @spec = Gemspec.new(opts)
    end
  end
end
