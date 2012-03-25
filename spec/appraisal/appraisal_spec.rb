require 'spec_helper'
require 'appraisal/appraisal'

describe Appraisal::Appraisal do
  it "creates a proper bundle command" do
    appraisal = Appraisal::Appraisal.new('fake', 'fake')
    appraisal.stub(:gemfile_path).and_return("/home/test/test directory")

    appraisal.bundle_command.should == "bundle install --gemfile='/home/test/test directory'"
  end
end
