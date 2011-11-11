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

  it "preserves dependency order" do
    gemfile = Appraisal::Gemfile.new
    gemfile.gem "one"
    gemfile.gem "two"
    gemfile.gem "three"
    gemfile.to_s.should =~ /one.*two.*three/m
  end

  it "supports symbol sources" do
    gemfile = Appraisal::Gemfile.new
    gemfile.source :one
    gemfile.to_s.strip.should == %{source :one}
  end
end
