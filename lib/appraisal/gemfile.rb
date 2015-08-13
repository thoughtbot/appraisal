require "appraisal/bundler_dsl"

module Appraisal
  autoload :Gemspec, "appraisal/gemspec"
  autoload :GitSource, "appraisal/git_source"
  autoload :Group, "appraisal/group"
  autoload :PathSource, "appraisal/path_source"
  autoload :Platform, "appraisal/platform"
  autoload :Source, "appraisal/source"

  # Load bundler Gemfiles and merge dependencies
  class Gemfile < BundlerDSL
    def load(path)
      if ::File.exist?(path)
        run(IO.read(path))
      end
    end

    def run(definitions)
      instance_eval(definitions, __FILE__, __LINE__) if definitions
    end

    def dup
      Gemfile.new.tap do |gemfile|
        gemfile.run(for_dup)
      end
    end
  end
end
