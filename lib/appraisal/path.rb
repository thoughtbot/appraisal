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
        <<-OUTPUT.rstrip
path #{Utils.prefix_path(@source).inspect} do
#{indent(super)}
end
        OUTPUT
      else
        <<-OUTPUT.rstrip
path #{Utils.prefix_path(@source).inspect}, #{Utils.format_string(@options)} do
#{indent(super)}
end"
        OUTPUT
      end
    end

    # :nodoc:
    def for_dup
      if @options.empty?
        <<-OUTPUT.rstrip
path #{@source.inspect} do
#{indent(super)}
end
        OUTPUT
      else
        <<-OUTPUT.rstrip
path #{@source.inspect}, #{Utils.format_string(@options)} do
#{indent(super)}
end
        OUTPUT
      end
    end
  end
end
