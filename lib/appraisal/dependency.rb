module Appraisal
  # Dependency on a gem and optional version requirements
  class Dependency
    
    attr_reader :name, :requirements

    def initialize(name, requirements)
      @name = name
      @requirements = requirements
      update_path!
    end

    def to_s
      gem_name = %{gem "#{name}"}
      if requirements.nil? || requirements.empty?
        gem_name
      else
        "#{gem_name}, #{inspect_requirements}"
      end
    end

    private

    def inspect_requirements
      requirements.map { |requirement| requirement.inspect.gsub(/^\{|\}$/, '') }.join(", ")
    end

    def update_path!
      if hash = requirements.detect { |req| req.is_a?(Hash) && (req[:path] || req['path']) }
        string_or_symbol = hash.keys.include?('path') ? 'path' : :path
        index = requirements.index(hash)
        path = hash[string_or_symbol]
        new_path = if path =~ /^(?:\/|\S:)/ #absolute
          path
        else #relative
          "../#{path}"
        end
        @requirements[index] = {string_or_symbol => new_path}
      end
    end
  end
end

