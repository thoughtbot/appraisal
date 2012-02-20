require 'pathname'

module Appraisal
  # Dependency on a gem and optional version requirements
  class Dependency

    PATH_KEY = 'path'
    PATH_KEY_SYMBOL = :path

    attr_reader :name, :requirements

    def initialize(name, requirements)
      
      @name = name
      @requirements = requirements
      @path_rewritten = false

      unless path_rewritten?
        rewrite_path! 
      end
    end

    def path_rewritten!
      @path_rewritten = true
    end

    def path_rewritten?
      @path_rewritten
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

    def rewrite_path!
    
      if hash = requirements.detect { |req| req.is_a?(Hash) && (req[PATH_KEY_SYMBOL] || req[PATH_KEY]) }

        string_or_symbol = hash.keys.include?(PATH_KEY) ? PATH_KEY : PATH_KEY_SYMBOL
        index = requirements.index(hash)
        path = Pathname.new(hash[string_or_symbol])
        @requirements[index][string_or_symbol] = path.absolute? ? path.to_s : (Pathname.new("../") + path).cleanpath.to_s
    
        path_rewritten!
      end
    end
  end
end

