module Appraisal
  # Dependency on a gem and optional version requirements
  class Dependency
    attr_reader :name, :requirements

    def initialize(name, requirements)
      @name = name
      @requirements = requirements
    end

    def to_s
      if no_requirements?
        gem_name
      else
        "#{gem_name}, #{inspect_requirements}"
      end
    end

    private

    def gem_name
      %{gem "#{name}"}
    end

    def no_requirements?
      requirements.nil? || requirements.empty?
    end

    def inspect_requirements
      requirements.map { |requirement| requirement.inspect.gsub(/^\{|\}$/, '') }.join(", ")
    end
  end
end
