require 'appraisal/dependency_list'
require 'appraisal/utils'

module Appraisal
  class Group
    def initialize(group_names)
      @nested = Gemfile.new
      @group_names = group_names
    end

    def run(&block)
      @nested.run(&block)
    end

    def to_s
      "group #{Utils.format_arguments(@group_names)} do\n" +
        @nested.to_s.strip.gsub(/^/, '  ') + "\nend"
    end
  end
end
