# frozen_string_literal: true

module Appraisal
  # Contains methods for various operations
  module Utils
    def self.support_parallel_installation?
      Gem::Version.create(Bundler::VERSION) >= Gem::Version.create("1.4.0.pre.1")
    end

    def self.support_git_local_installation?
      Gem::Version.create(Bundler::VERSION) > Gem::Version.create("2.4.22")
    end

    # Appraisal needs to print Gemfiles in the oldest Ruby syntax that is supported by Appraisal.
    # Otherwise, a project would not be able to use Appraisal to test compatibility
    #   with older versions of Ruby, which is a core use case for Appraisal.
    def self.format_string(object, enclosing_object = false)
      case object
      when Hash
        items = object.map do |key, value|
          format_hash_value(key, value)
        end

        if enclosing_object
          "{ #{items.join(", ")} }"
        else
          items.join(", ")
        end
      else
        object.inspect
      end
    end

    # Appraisal needs to print Gemfiles in the oldest Ruby syntax that is supported by Appraisal.
    # This means formatting Hashes as Rockets, until support for Ruby 1.8 is dropped.
    # Regardless of what Ruby is used to generate appraisals,
    #   generated appraisals may need to run on a different Ruby version.
    # Generated appraisals should use a syntax compliant with the oldest supported Ruby version.
    def self.format_hash_value(key, value)
      key = format_string(key, true)
      value = format_string(value, true)

      "#{key} => #{value}"
    end

    def self.format_arguments(arguments)
      return if arguments.empty?

      arguments.map { |object| format_string(object, false) }.join(", ")
    end

    def self.join_parts(parts)
      parts.reject(&:nil?).reject(&:empty?).join("\n\n").rstrip
    end

    def self.prefix_path(path)
      if path !~ %r{^(?:/|\S:)} && path !~ %r{^\S+://} && path !~ /^\S+@\S+:/
        cleaned_path = path.gsub(%r{(^|/)\.(?:/|$)}, '\\1')
        File.join("..", cleaned_path)
      else
        path
      end
    end

    def self.bundler_version
      Gem::Specification.detect { |spec| spec.name == "bundler" }.version.to_s
    end
  end
end
