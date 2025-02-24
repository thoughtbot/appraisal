# frozen_string_literal: true

require "appraisal/bundler_dsl"
require "appraisal/utils"

module Appraisal
  class Group < BundlerDSL
    def initialize(group_names)
      super()
      @group_names = group_names
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
group #{Utils.format_arguments(@group_names)} do
#{indent(output_dependencies)}
end
      OUTPUT
    end
  end
end
