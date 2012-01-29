require 'spec_helper'
require 'appraisal/group'
describe Appraisal::Group do

  let(:group) { Appraisal::Group.new(['foo'], deps) }

  let(:deps) {   5.times.to_a.map { Appraisal::Dependency.new('foo', []).to_s }.join("\n")}

  it "should create a group on to_s" do
    group.to_s.should == "group :foo do\n  gem \"foo\"\n  gem \"foo\"\n  gem \"foo\"\n  gem \"foo\"\n  gem \"foo\"\nend"
  end

end