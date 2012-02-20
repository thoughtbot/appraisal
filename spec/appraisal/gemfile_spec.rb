require 'spec_helper'
require 'appraisal/gemfile'

describe Appraisal::Gemfile do

  let(:gemfile) { Appraisal::Gemfile.new }

  let(:duped_gemfile) { gemfile.dup }

  it "supports gemfiles without sources" do
    gemfile.to_s.strip.should == ""
  end

  it "supports multiple sources" do
    gemfile.source "one"
    gemfile.source "two"
    gemfile.to_s.strip.should == %{source "one"\nsource "two"}
  end

  it "preserves dependency order" do
    gemfile.gem "one"
    gemfile.gem "two"
    gemfile.gem "three"
    gemfile.to_s.should =~ /one.*two.*three/m
  end

  it "supports symbol sources" do
    gemfile.source :one
    gemfile.to_s.strip.should == %{source :one}
  end

  it "should duplicate all gemfile contents" do
    gemfile.gem 'foo'
    gemfile.gem 'bar'
    gemfile.source 'one'

    duped_gemfile.should_not == gemfile
    duped_gemfile.dependencies.map(&:object_id).should_not == gemfile.dependencies.map(&:object_id)
    duped_gemfile.sources.should == gemfile.sources
  end

  it "should reject dependency by name" do
    gemfile.gem "foobar"
    gemfile.dependencies.should_not be_empty
    gemfile.reject_dependency!("foobar")
    gemfile.dependencies.should be_empty
  end

  it "should have a group" do
    gemfile.group :foo do |file|
      file.gem "foo"
    end
    gemfile.to_s.should =~ /group :foo do/
  end

end
