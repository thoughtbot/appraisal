require 'spec_helper'
require 'appraisal/file'

describe Appraisal::File do
  it "should complain when no Appraisals file is found" do
    ::File.stub(:exist?).with("Appraisals").and_return(false)
    expect { described_class.new }.to raise_error(Appraisal::AppraisalsFileNotFound)
  end
end
