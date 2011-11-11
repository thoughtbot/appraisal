require 'spec_helper'
require 'appraisal/gemfile'

describe Appraisal::Gemfile do
  it "supports gemfiles without sources" do
    gemfile = Appraisal::Gemfile.new
    gemfile.to_s.strip.should == ""
  end

  it "supports multiple sources" do
    gemfile = Appraisal::Gemfile.new
    gemfile.source "one"
    gemfile.source "two"
    gemfile.to_s.strip.should == %{source "one"\nsource "two"}
  end
end
