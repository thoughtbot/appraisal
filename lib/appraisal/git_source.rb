module Appraisal
  class GitSource < Gemfile
    def initialize(source, options = {})
      super()
      @source = source
      @options = options
    end

    def run(&block)
      instance_exec(&block)
    end

    def to_s
      dependencies = super.strip.gsub(/^/, '  ')

      if @options.empty?
        "git #{@source.inspect} do\n#{dependencies}\nend"
      else
        "git #{@source.inspect}, #{@options.inspect} do\n#{dependencies}\nend"
      end
    end
  end
end
