require 'spec_helper'
require 'appraisal/dependency'

describe Appraisal::Dependency do

  let(:dependency) { Appraisal::Dependency.new('foo', deps) }

  let(:duped_dependency) { dependency.dup }

  context "normal operation" do
    let(:deps) { [] }
    it 'should create basic dep' do
      dependency.path_rewritten?.should be_false
      dependency.to_s.should == 'gem "foo"'
    end

    it "should create a duplicate of the dependency" do
      duped_dependency.should_not == dependency
    end

  end

  context ':path rewrites' do

    context 'already path_rewritten' do
      let (:deps) { [{:path => "../foo"}] }

      it "should not rewrite path" do
        duped_dependency.to_s.should == 'gem "foo", :path=>"../../foo"'
        duped_dependency.path_rewritten?.should be_true
      end

    end

    context "relative path" do
      let (:deps) { [{:path => "../foo"}] }
      
      it "should change relative path" do
        dependency.to_s.should == 'gem "foo", :path=>"../../foo"'
        dependency.path_rewritten?.should be_true
      end

    end

    context "absolute path" do
      let (:deps) { [{:path => "/foo"}] }
      
      it "should maintain absolute path" do
        dependency.to_s.should == 'gem "foo", :path=>"/foo"'
        dependency.path_rewritten?.should be_true
      end
    end

      context "absolute path string key" do
      let (:deps) { [{"path" => "/foo"}] }
      
      it "should maintain absolute path" do
        dependency.to_s.should == 'gem "foo", "path"=>"/foo"'
        dependency.path_rewritten?.should be_true
      end
    end

  end

end