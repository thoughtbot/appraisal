module Appraisal
  # Contains methods for various operations
  module Utils
    def self.support_parallel_installation?
      Gem::Version.create(Bundler::VERSION) >= Gem::Version.create('1.4.0.pre.1')
    end

    def self.format_string(object, enclosing_object = false)
      case object
      when Hash
        items = object.map do |key, value|
          "#{format_string(key, true)} => #{format_string(value, true)}"
        end

        if enclosing_object
          "{ #{items.join(', ')} }"
        else
          items.join(', ')
        end
      else
        object.inspect
      end
    end

    def self.format_arguments(arguments)
      arguments.map { |object| format_string(object, false) }.join(', ')
    end
  end
end
