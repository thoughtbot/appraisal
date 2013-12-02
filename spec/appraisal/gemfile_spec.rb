require 'spec_helper'
require 'appraisal/gemfile'
require 'active_support/core_ext/string/strip'

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

  it 'supports group syntax' do
    gemfile = Appraisal::Gemfile.new

    gemfile.group :development, :test do
      gem "one"
    end

    gemfile.to_s.should == <<-GEMFILE.strip_heredoc.strip
      group :development, :test do
        gem "one"
      end
    GEMFILE
  end

  it 'supports platforms syntax' do
    gemfile = Appraisal::Gemfile.new

    gemfile.platforms :jruby do
      gem "one"
    end

    gemfile.to_s.should == <<-GEMFILE.strip_heredoc.strip
      platforms :jruby do
        gem "one"
      end
    GEMFILE
  end

  context "excess new line" do
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
