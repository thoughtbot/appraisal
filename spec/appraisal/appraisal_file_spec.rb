# frozen_string_literal: true

require "spec_helper"
require "appraisal/appraisal_file"

# Requiring this to make the test pass on Rubinius 2.2.5
# https://github.com/rubinius/rubinius/issues/2934
require "rspec/matchers/composable"
require "rspec/matchers/built_in/raise_error"

RSpec.describe Appraisal::AppraisalFile do
  it "complains when no Appraisals file is found" do
    allow(File).to receive(:exist?).with(/Gemfile/).and_return(true)
    allow(File).to receive(:exist?).with("Appraisals").and_return(false)
    expect { described_class.new }.to raise_error(Appraisal::AppraisalsNotFound)
  end

  describe "#customize_gemfiles" do
    before do
      allow(File).to receive(:exist?).with(anything).and_return(true)
      allow(IO).to receive(:read).with(anything).and_return("")
    end

    context "when no arguments are given" do
      subject { described_class.new.customize_gemfiles }

      it "raises an error" do
        expect { subject }.to raise_error(LocalJumpError)
      end
    end

    context "when a block is given" do
      context "when the block returns a hash with :heading key" do
        subject do
          described_class.new.customize_gemfiles do
            {:heading => "foo"}
          end
        end

        it "sets the heading" do
          expect { subject }.to change { Appraisal::Customize.heading }.to("foo")
        end
      end

      context "when the block returns a hash with :single_quotes key" do
        subject do
          described_class.new.customize_gemfiles do
            {:single_quotes => true}
          end
        end

        it "sets the single_quotes" do
          expect { subject }.to change { Appraisal::Customize.single_quotes }.to(true)
        end
      end

      context "when the block returns a hash with :heading and :single_quotes keys" do
        subject do
          described_class.new.customize_gemfiles do
            {:heading => "foo", :single_quotes => true}
          end
        end

        it "sets the heading and single_quotes" do
          subject
          expect(Appraisal::Customize.heading).to eq("foo")
          expect(Appraisal::Customize.single_quotes).to be(true)
        end
      end
    end
  end
end
