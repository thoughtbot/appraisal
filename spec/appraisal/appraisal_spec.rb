require 'spec_helper'
require 'appraisal/appraisal'

describe Appraisal::Appraisal do
  it "creates a proper bundle command" do
    appraisal = Appraisal::Appraisal.new('fake', 'fake')
    appraisal.stub(:gemfile_path).and_return("/home/test/test directory")

    appraisal.bundle_command.should == "bundle check --gemfile='/home/test/test directory' || bundle install --gemfile='/home/test/test directory'"
  end

  it "cleans up spaces and punctuation when outputting its gemfile" do
    appraisal = Appraisal::Appraisal.new("This! is my appraisal name.", "Gemfile")
    appraisal.gemfile_path.should =~ /This_is_my_appraisal_name.gemfile/
  end
end
