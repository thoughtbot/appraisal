module Appraisal
  class Platform < Gemfile
    def initialize(platform_names)
      super()
      @platform_names = platform_names
    end

    def run(&block)
      instance_exec(&block)
    end

    def to_s
      "platforms #{@platform_names.map(&:inspect).join(', ')} do\n" +
        super.strip.gsub(/^/, '  ') + "\nend"
    end
  end
end
