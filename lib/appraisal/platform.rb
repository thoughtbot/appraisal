# frozen_string_literal: true

require "appraisal/bundler_dsl"
require "appraisal/utils"

module Appraisal
  class Platform < BundlerDSL
    def initialize(platform_names)
      super()
      @platform_names = platform_names
    end

    def to_s
      formatted_output(super)
    end

    # :nodoc:
    def for_dup
      formatted_output(super)
    end

    private

    def formatted_output(output_dependencies)
      <<-OUTPUT.rstrip
platforms #{Utils.format_arguments(@platform_names)} do
#{indent(output_dependencies)}
end
      OUTPUT
    end
  end
end
