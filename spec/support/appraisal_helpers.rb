require 'rspec/expectations/expectation_target'

module AppraisalHelpers
  include Aruba::Api

  def build_appraisal_file(content)
    write_file 'Appraisals', content
  end

  def expect_file(filename)
    FileExpectationTarget.new(filename)
  end

  class FileExpectationTarget < RSpec::Expectations::ExpectationTarget
    def to(matcher = nil, message = nil, &block)
      # TODO: Better matcher matching
      if matcher.name == 'be_predicate' && matcher.expected == 'exists'
        matcher = FileExistsMatcher.new
      end

      super(matcher, message, &block)
    end
  end

  class FileExistsMatcher
    include Aruba::Api

    def matches?(expected)
      @expected = expected
      in_current_dir { File.exists?(@expected) }
    end

    def failure_message_for_should
      "file #{@expected.inspect} does not exist.\n"
    end

    def failure_message_for_should_not
      "file #{@expected.inspect} exists.\n"
    end
  end
end
