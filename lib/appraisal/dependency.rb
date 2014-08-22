require 'appraisal/utils'

module Appraisal
  # Dependency on a gem and optional version requirements
  class Dependency
    attr_accessor :requirements
    attr_reader :name

    def initialize(name, requirements)
      @name = name
      @requirements = requirements
    end

    def to_s
      if no_requirements?
        gem_name
      else
        "#{gem_name}, #{Utils.format_arguments(requirements)}"
      end
    end

    private

    def gem_name
      %{gem "#{name}"}
    end

    def no_requirements?
      requirements.nil? || requirements.empty?
    end
  end
end
