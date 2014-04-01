require 'spec_helper'
require 'appraisal/gemspec'

describe Appraisal::Gemspec do
  describe '#to_s' do
    context 'when path is an absolute path' do
      it 'returns the path as-is' do
        gemspec = Appraisal::Gemspec.new(path: '/tmp')

        expect(gemspec.to_s).to eq 'gemspec :path => "/tmp"'
      end
    end

    context 'when path contains "./"' do
      it 'strips out "./"' do
        gemspec = Appraisal::Gemspec.new(path: './tmp/./appraisal././')

        expect(gemspec.to_s).to eq 'gemspec :path => "../tmp/appraisal./"'
      end
    end
  end
end
