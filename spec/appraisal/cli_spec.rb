# frozen_string_literal: true

require "spec_helper"
require "appraisal/cli"
require "appraisal/appraisal_file"
require "appraisal/command"
require "appraisal/version"
require "tmpdir"

RSpec.describe Appraisal::CLI do
  include StreamHelpers

  describe ".exit_on_failure?" do
    it "returns true so Thor exits non-zero on failure" do
      expect(described_class.exit_on_failure?).to eq(true)
    end
  end

  describe ".help" do
    let(:shell) { Thor::Shell::Basic.new }

    it "prints usage information" do
      allow(File).to receive(:exist?).with("Appraisals").and_return(false)

      output = capture(:stdout) { described_class.help(shell) }

      expect(output).to include("Appraisal: Find out what your Ruby gems are worth.")
      expect(output).not_to include("Available Appraisal(s):")
    end

    it "lists available appraisals when an Appraisals file exists" do
      allow(File).to receive(:exist?).with("Appraisals").and_return(true)
      allow(Appraisal::AppraisalFile).to receive(:each).and_yield(double("Appraisal", name: "rails-6"))

      output = capture(:stdout) { described_class.help(shell) }

      expect(output).to include("Available Appraisal(s):")
      expect(output).to include("- rails-6")
    end
  end

  describe "#install" do
    it "generates, installs, and relativizes every appraisal" do
      appraisal = double("Appraisal")
      allow(Appraisal::AppraisalFile).to receive(:each).and_yield(appraisal)
      allow(appraisal).to receive(:write_gemfile)
      allow(appraisal).to receive(:install)
      allow(appraisal).to receive(:relativize)

      described_class.new.install

      expect(appraisal).to have_received(:write_gemfile)
      expect(appraisal).to have_received(:install)
      expect(appraisal).to have_received(:relativize)
    end
  end

  describe "#generate" do
    it "writes each appraisal's gemfile" do
      appraisal = double("Appraisal", write_gemfile: nil)
      allow(Appraisal::AppraisalFile).to receive(:each).and_yield(appraisal)

      described_class.new.generate

      expect(appraisal).to have_received(:write_gemfile)
    end
  end

  describe "#clean" do
    it "removes generated gemfiles and lockfiles" do
      Dir.mktmpdir do |dir|
        Dir.chdir(dir) do
          FileUtils.mkdir("gemfiles")
          FileUtils.touch("gemfiles/one.gemfile")
          FileUtils.touch("gemfiles/one.gemfile.lock")

          described_class.new.clean

          expect(Dir["gemfiles/*"]).to eq([])
        end
      end
    end
  end

  describe "#update" do
    it "regenerates gemfiles and updates every appraisal with the given gems" do
      appraisal = double("Appraisal", write_gemfile: nil, update: nil)
      allow(Appraisal::AppraisalFile).to receive(:each).and_yield(appraisal)

      described_class.new.update("rails", "rspec")

      expect(appraisal).to have_received(:update).with(%w[rails rspec])
    end
  end

  describe "#list" do
    it "prints the name of each defined appraisal" do
      appraisal_file = double("AppraisalFile", appraisals: [double(name: "one"), double(name: "two")])
      allow(Appraisal::AppraisalFile).to receive(:new).and_return(appraisal_file)

      output = capture(:stdout) { described_class.new.list }

      expect(output).to eq("one\ntwo\n")
    end
  end

  describe "#version" do
    it "prints the gem version" do
      output = capture(:stdout) { described_class.new.version }

      expect(output).to eq("Appraisal #{Appraisal::VERSION}\n")
    end
  end

  describe "#method_missing" do
    it "runs the command against the single matching appraisal" do
      matching = double("Appraisal", name: "rails6", gemfile_path: "gemfiles/rails6.gemfile")
      allow(Appraisal::AppraisalFile).to receive(:new)
        .and_return(double("AppraisalFile", appraisals: [matching]))
      command = double("Command", run: true)
      allow(Appraisal::Command).to receive(:new)
        .with(["rspec"], gemfile: "gemfiles/rails6.gemfile")
        .and_return(command)

      described_class.new.send(:rails6, "rspec")

      expect(command).to have_received(:run)
    end

    it "runs the command against every appraisal when no name matches" do
      stub_const("ARGV", ["rspec"])
      one = double("Appraisal", name: "one", gemfile_path: "gemfiles/one.gemfile")
      two = double("Appraisal", name: "two", gemfile_path: "gemfiles/two.gemfile")
      allow(Appraisal::AppraisalFile).to receive(:new)
        .and_return(double("AppraisalFile", appraisals: [one, two]))
      allow(Appraisal::AppraisalFile).to receive(:each).and_yield(one).and_yield(two)
      command = double("Command", run: true)
      allow(Appraisal::Command).to receive(:new).and_return(command)

      described_class.new.send(:rspec)

      expect(Appraisal::Command).to have_received(:new).with(["rspec"], gemfile: "gemfiles/one.gemfile")
      expect(Appraisal::Command).to have_received(:new).with(["rspec"], gemfile: "gemfiles/two.gemfile")
    end
  end
end
