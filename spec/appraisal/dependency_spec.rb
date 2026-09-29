# frozen_string_literal: true

require "spec_helper"
require "appraisal/dependency"

RSpec.describe Appraisal::Dependency do
  describe "#to_s" do
    it "renders a bare gem declaration" do
      dependency = described_class.new("rails", [])

      expect(dependency.to_s).to eq(%(gem "rails"))
    end

    it "renders version requirements" do
      dependency = described_class.new("rails", ["7.0"])

      expect(dependency.to_s).to eq(%(gem "rails", "7.0"))
    end

    it "prefixes a relative :path requirement" do
      dependency = described_class.new("rails", [{ path: "../rails" }])

      expect(dependency.to_s).to eq(%(gem "rails", path: "../../rails"))
    end

    it "prefixes a relative :git requirement" do
      dependency = described_class.new("rails", [{ git: "../rails" }])

      expect(dependency.to_s).to eq(%(gem "rails", git: "../../rails"))
    end
  end

  describe "#for_dup" do
    it "renders requirements without path-prefixing" do
      dependency = described_class.new("rails", [{ path: "../rails" }])

      expect(dependency.for_dup).to eq(%(gem "rails", path: "../rails"))
    end
  end

  describe "#no_requirements?" do
    it "is true when requirements are nil" do
      dependency = described_class.new("rails", nil)

      expect(dependency.send(:no_requirements?)).to eq(true)
    end

    it "is true when requirements are empty" do
      dependency = described_class.new("rails", [])

      expect(dependency.send(:no_requirements?)).to eq(true)
    end

    it "is false when requirements are present" do
      dependency = described_class.new("rails", ["7.0"])

      expect(dependency.send(:no_requirements?)).to eq(false)
    end
  end
end
