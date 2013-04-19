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

  describe "has no excess new line" do
    context "no contents" do
      it "shows empty string" do
        gemfile = Appraisal::Gemfile.new
        gemfile.to_s.should eq ""
      end
    end

    context "full contents" do
      it "does not show newline at end" do
        gemfile = Appraisal::Gemfile.new
        gemfile.source "source"
        gemfile.gem "gem"
        gemfile.gemspec
        gemfile.to_s.should =~ /[^\n]\z/m
      end
    end

    context "no gemspec" do
      it "does not show newline at end" do
        gemfile = Appraisal::Gemfile.new
        gemfile.source "source"
        gemfile.gem "gem"
        gemfile.to_s.should =~ /[^\n]\z/m
      end
    end
  end
end
