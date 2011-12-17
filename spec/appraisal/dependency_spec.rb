require 'spec_helper'
require 'appraisal/dependency'

describe Appraisal::Dependency do

  let(:dependency) { Appraisal::Dependency.new('foo', deps) }

  context "relative path" do
    let (:deps) { [{:path => "../foo"}] }
    
    it "should change relative path" do
      dependency.to_s.should == 'gem "foo", :path=>"../../foo"'
    end
  end

  context "absolute path" do
    let (:deps) { [{:path => "/foo"}] }
    
    it "should maintain absolute path" do
      dependency.to_s.should == 'gem "foo", :path=>"/foo"'
    end
  end


end