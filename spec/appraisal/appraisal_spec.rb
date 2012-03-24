require 'spec_helper'
require 'appraisal/appraisal'

describe Appraisal::Appraisal do
  it "cleans up spaces and punctunation when outputting its gemfile" do
    appraisal = Appraisal::Appraisal.new("This! is my appraisal name.", "Gemfile")
    appraisal.gemfile_path.should =~ /This_is_my_appraisal_name.gemfile/
  end
end
