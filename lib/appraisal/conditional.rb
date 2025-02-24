# frozen_string_literal: true

require "appraisal/bundler_dsl"
require "appraisal/utils"

module Appraisal
  class Conditional < BundlerDSL
    def initialize(condition)
      super()
      @condition = condition
    end

    def to_s
      <<-OUTPUT.rstrip
install_if #{@condition} do
#{indent(super)}
end
      OUTPUT
    end

    # :nodoc:
    def for_dup
      return unless @condition.is_a?(String)

      <<-OUTPUT.rstrip
install_if #{@condition} do
#{indent(super)}
end
      OUTPUT
    end
  end
end
