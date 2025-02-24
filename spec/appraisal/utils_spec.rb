# frozen_string_literal: true

require "spec_helper"
require "appraisal/utils"

RSpec.describe Appraisal::Utils do
  describe ".format_string" do
    it "prints out a nice looking hash without brackets with old syntax" do
      hash = {:foo => "bar"}
      expect(described_class.format_string(hash)).to eq(':foo => "bar"')

      hash = {"baz" => {:ball => "boo"}}
      expect(described_class.format_string(hash))
        .to eq('"baz" => { :ball => "boo" }')
    end
  end

  describe ".format_arguments" do
    before { stub_const("RUBY_VERSION", "1.8.7") }

    it "prints out arguments without enclosing square brackets" do
      arguments = [:foo, {:bar => {:baz => "ball"}}]

      expect(described_class.format_arguments(arguments)).to eq(
        ':foo, :bar => { :baz => "ball" }',
      )
    end

    it "returns nil if arguments is empty" do
      arguments = []

      expect(described_class.format_arguments(arguments)).to be_nil
    end
  end

  describe ".prefix_path" do
    it "prepends two dots in front of relative path" do
      expect(described_class.prefix_path("test")).to eq "../test"
    end

    it "replaces single dot with two dots" do
      expect(described_class.prefix_path(".")).to eq "../"
    end

    it "ignores absolute path" do
      expect(described_class.prefix_path("/tmp")).to eq "/tmp"
    end

    it "strips out './' from path" do
      expect(described_class.prefix_path("./tmp/./appraisal././")).to eq "../tmp/appraisal./"
    end

    it "does not prefix Git uri" do
      expect(described_class.prefix_path("git@github.com:bacon/bacon.git")).to eq "git@github.com:bacon/bacon.git"
      expect(described_class.prefix_path("git://github.com/bacon/bacon.git")).to eq "git://github.com/bacon/bacon.git"
      expect(described_class.prefix_path("https://github.com/bacon/bacon.git")).to eq("https://github.com/bacon/bacon.git")
    end
  end

  describe ".bundler_version" do
    it "returns the bundler version" do
      bundler = double("Bundler", :name => "bundler", :version => "a.b.c")
      allow(Gem::Specification).to receive(:detect).and_return(bundler)

      version = described_class.bundler_version

      expect(version).to eq "a.b.c"
      expect(Gem::Specification).to have_received(:detect)
    end
  end
end
