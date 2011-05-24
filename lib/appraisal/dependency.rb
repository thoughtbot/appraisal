module Appraisal
  # Dependency on a gem and optional version requirements
  class Dependency
    attr_reader :name, :requirements

    def initialize(name, requirements)
      @name = name
      @requirements = requirements
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
  end
end

