module Appraisal
  # An ordered hash implementation for Ruby 1.8.7 compatibility. This is not
  # a complete implementation, but it covers Appraisal's specific needs.
  class OrderedHash < ::Hash
    # Hashes are ordered in Ruby 1.9.
    if RUBY_VERSION < '1.9'
      def initialize(*args, &block)
        super
        @keys = []
      end

      def []=(key, value)
        @keys << key unless has_key?(key)
        super
      end

      def values
        @keys.collect { |key| self[key] }
      end
    end
  end
end
