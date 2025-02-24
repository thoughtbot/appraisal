# frozen_string_literal: true

require "appraisal/bundler_dsl"
require "appraisal/utils"

module Appraisal
  class Source < BundlerDSL
    def initialize(source)
      super()
      @source = source
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
source #{@source.inspect} do
#{indent(output_dependencies)}
end
      OUTPUT
    end
  end
end
