# frozen_string_literal: true

require "spec_helper"
require "appraisal/command"

RSpec.describe Appraisal::Command do
  include StreamHelpers

  before do
    # Bundler.with_original_env swaps in the environment captured when
    # Bundler first loaded, which predates APPRAISAL_UNDER_TEST being set by
    # spec_helper. Stub it to preserve the current environment instead, but
    # still restore it afterwards, mirroring the real implementation.
    allow(Bundler).to receive(:with_original_env) do |&block|
      backup = ENV.to_hash
      begin
        block.call
      ensure
        ENV.replace(backup)
      end
    end

    allow(Appraisal::Utils).to receive(:bundler_version).and_return("2.5.0")
  end

  describe "#initialize" do
    it "prefixes an array command that does not start with bundle" do
      command = described_class.new(["rake", "-T"])

      expect(command.command).to eq(%w[bundle exec rake -T])
    end

    it "does not prefix an array command that already starts with bundle" do
      command = described_class.new(%w[bundle install])

      expect(command.command).to eq(%w[bundle install])
    end

    it "does not prefix a string command that already starts with bundle" do
      command = described_class.new("bundle install")

      expect(command.command).to eq("bundle install")
    end

    it "defaults gemfile to nil and env to an empty hash" do
      command = described_class.new(%w[bundle install])

      expect(command.gemfile).to be_nil
      expect(command.env).to eq({})
    end

    it "stores the given gemfile and env options" do
      command = described_class.new(%w[bundle install], gemfile: "foo.gemfile", env: { "FOO" => "bar" })

      expect(command.gemfile).to eq("foo.gemfile")
      expect(command.env).to eq("FOO" => "bar")
    end
  end

  describe "#run" do
    def stub_bundler_available(command, available: true)
      allow(command).to receive(:system)
        .with("gem list --silent -i bundler -v 2.5.0")
        .and_return(available)
    end

    it "runs the command through Kernel.system and does not exit on success" do
      command = described_class.new(%w[bundle install])
      stub_bundler_available(command)
      allow(Kernel).to receive(:system).with("bundle install").and_return(true)
      allow(command).to receive(:exit)

      capture(:stdout) { command.run }

      expect(Kernel).to have_received(:system).with("bundle install")
      expect(command).not_to have_received(:exit)
    end

    it "runs a string command as-is" do
      command = described_class.new("bundle install")
      stub_bundler_available(command)
      allow(Kernel).to receive(:system).with("bundle install").and_return(true)

      capture(:stdout) { command.run }

      expect(Kernel).to have_received(:system).with("bundle install")
    end

    it "exits with status 1 when the command fails" do
      command = described_class.new(%w[bundle install])
      stub_bundler_available(command)
      allow(Kernel).to receive(:system).with("bundle install").and_return(false)
      allow(command).to receive(:exit)

      capture(:stdout) { command.run }

      expect(command).to have_received(:exit).with(1)
    end

    it "announces and exports BUNDLE_GEMFILE when a gemfile is set" do
      command = described_class.new(%w[bundle install], gemfile: "foo.gemfile")
      stub_bundler_available(command)
      observed_env = nil
      allow(Kernel).to receive(:system) do
        observed_env = ENV.to_hash
        true
      end

      output = capture(:stdout) { command.run }

      expect(output).to include("BUNDLE_GEMFILE=foo.gemfile bundle install")
      expect(observed_env["BUNDLE_GEMFILE"]).to eq("foo.gemfile")
    end

    it "announces the command without a gemfile" do
      command = described_class.new(%w[bundle install])
      stub_bundler_available(command)
      allow(Kernel).to receive(:system).and_return(true)

      output = capture(:stdout) { command.run }

      expect(output).to include(">> bundle install")
    end

    it "sets APPRAISAL_INITIALIZED and merges the given environment variables" do
      command = described_class.new(%w[bundle install], env: { "CUSTOM_VAR" => "1" })
      stub_bundler_available(command)
      observed_env = nil
      allow(Kernel).to receive(:system) do
        observed_env = ENV.to_hash
        true
      end

      capture(:stdout) { command.run }

      expect(observed_env["APPRAISAL_INITIALIZED"]).to eq("1")
      expect(observed_env["CUSTOM_VAR"]).to eq("1")
    end

    it "merges GEM_HOME and clears GEM_PATH when running under the appraisal test suite" do
      original_gem_home = ENV["GEM_HOME"]
      command = described_class.new(%w[bundle install])
      stub_bundler_available(command)
      observed_env = nil
      allow(Kernel).to receive(:system) do
        observed_env = ENV.to_hash
        true
      end

      capture(:stdout) { command.run }

      expect(observed_env["GEM_HOME"]).to eq(original_gem_home)
      expect(observed_env["GEM_PATH"]).to eq("")
    end

    context "when bundler is not already installed" do
      it "reinstalls bundler before running the command" do
        command = described_class.new(%w[bundle install])
        stub_bundler_available(command, available: false)
        allow(command).to receive(:system).with("gem install bundler --version 2.5.0").and_return(true)
        allow(Kernel).to receive(:system).and_return(true)

        output = capture(:stdout) { command.run }

        expect(output).to include("Reinstall Bundler")
        expect(command).to have_received(:system).with("gem install bundler --version 2.5.0")
      end

      it "prints an error and exits when reinstalling bundler fails" do
        command = described_class.new(%w[bundle install])
        stub_bundler_available(command, available: false)
        allow(command).to receive(:system).with("gem install bundler --version 2.5.0").and_return(false)
        allow(Kernel).to receive(:system).and_return(true)
        allow(command).to receive(:exit)

        output = capture(:stdout) { command.run }

        expect(output).to include("Bundler installation failed")
        expect(command).to have_received(:exit).with(1)
      end
    end
  end
end
