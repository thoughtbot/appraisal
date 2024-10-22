# frozen_string_literal: true

require "appraisal/bundler_dsl"
require "appraisal/utils"

module Appraisal
  class Path < BundlerDSL
    def initialize(source, options = {})
      super()
      @source = source
      @options = options
    end

    def to_s
      if @options.empty?
        "path #{Utils.prefix_path(@source).inspect} do\n#{indent(super)}\nend"
      else
        "path #{Utils.prefix_path(@source).inspect}, #{Utils.format_string(@options)} do\n" \
          "#{indent(super)}\nend"
      end
    end

    # :nodoc:
    def for_dup
      if @options.empty?
        "path #{@source.inspect} do\n#{indent(super)}\nend"
      else
        "path #{@source.inspect}, #{Utils.format_string(@options)} do\n" \
          "#{indent(super)}\nend"
      end
    end
  end
end
