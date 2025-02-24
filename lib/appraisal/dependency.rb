# frozen_string_literal: true

require "appraisal/utils"

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
      formatted_output(Utils.format_arguments(path_prefixed_requirements))
    end

    # :nodoc:
    def for_dup
      formatted_output(Utils.format_arguments(requirements))
    end

    private

    def path_prefixed_requirements
      requirements.map do |requirement|
        if requirement.is_a?(Hash)
          requirement[:path] = Utils.prefix_path(requirement[:path]) if requirement[:path]

          requirement[:git] = Utils.prefix_path(requirement[:git]) if requirement[:git]
        end

        requirement
      end
    end

    def formatted_output(output_requirements)
      [gem_name, output_requirements].compact.join(", ")
    end

    def gem_name
      %(gem "#{name}")
    end

    def no_requirements?
      requirements.nil? || requirements.empty?
    end
  end
end
