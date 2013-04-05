module Appraisal
  class Group < Gemfile
    def initialize(group_names)
      super()
      @group_names = group_names
    end

    def run(&block)
      instance_exec(&block)
    end

    def to_s
      "group #{@group_names.map(&:inspect).join(', ')} do\n" +
        super.strip.gsub(/^/, '  ') + "\nend"
    end
  end
end
