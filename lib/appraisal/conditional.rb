# frozen_string_literal: true

require "appraisal/bundler_dsl"
require "appraisal/utils"

module Appraisal
  # Represents an `install_if` block, installing its dependencies only when
  # the given condition evaluates to true when the generated Gemfile is run.
  class Conditional < BundlerDSL
    def initialize(condition)
      super()
      @condition = condition
    end

    def to_s
      "install_if #{@condition} do\n#{indent(super)}\nend"
    end

    # :nodoc:
    def for_dup
      return unless @condition.is_a?(String)

      "install_if #{@condition} do\n#{indent(super)}\nend"
    end
  end
end
