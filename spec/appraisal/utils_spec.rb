require 'spec_helper'
require 'appraisal/utils'

describe Appraisal::Utils do
  describe '.format_string' do
    it 'prints out a nice looking hash without a brackets' do
      hash = { :foo => 'bar', 'baz' => { :ball => 'boo' } }

      expect(Appraisal::Utils.format_string(hash)).to eq(
        ':foo => "bar", "baz" => { :ball => "boo" }'
      )
    end
  end

  describe '.format_arguments' do
    it 'prints out arguments without enclosing square brackets' do
      arguments = [:foo, bar: { baz: 'ball' }]

      expect(Appraisal::Utils.format_arguments(arguments)).to eq(
        ':foo, :bar => { :baz => "ball" }'
      )
    end
  end
end
