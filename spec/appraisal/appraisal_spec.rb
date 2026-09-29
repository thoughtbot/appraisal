# frozen_string_literal: true

require "spec_helper"
require "appraisal/appraisal"
require "appraisal/gemfile"
require "tempfile"
require "tmpdir"

RSpec.describe Appraisal::Appraisal do
  describe "Gemfile DSL delegation" do
    let(:appraisal) { Appraisal::Appraisal.new("test", Appraisal::Gemfile.new) }

    it "delegates #gem to the gemfile" do
      appraisal.gem("rails", "7.0")
      expect(appraisal.gemfile.to_s).to eq(%(gem "rails", "7.0"))
    end

    it "delegates #remove_gem to the gemfile" do
      appraisal.gem("rails")
      appraisal.remove_gem("rails")
      expect(appraisal.gemfile.to_s).to eq("")
    end

    it "delegates #source to the gemfile" do
      appraisal.source("https://gems.example.com")
      expect(appraisal.gemfile.to_s).to eq(%(source "https://gems.example.com"))
    end

    it "delegates #ruby to the gemfile" do
      appraisal.ruby("3.2.0")
      expect(appraisal.gemfile.to_s).to eq(%(ruby "3.2.0"))
    end

    it "delegates #git to the gemfile" do
      appraisal.git("git://example.com/repo.git") { gem "one" }
      expect(appraisal.gemfile.to_s).to include(%(git "git://example.com/repo.git" do))
    end

    it "delegates #path to the gemfile" do
      appraisal.path("../vendor") { gem "one" }
      expect(appraisal.gemfile.to_s).to include(%(path "../../vendor" do))
    end

    it "delegates #group to the gemfile" do
      appraisal.group(:test) { gem "one" }
      expect(appraisal.gemfile.to_s).to include("group :test do")
    end

    it "delegates #install_if to the gemfile" do
      appraisal.install_if("RUBY_VERSION >= '3.0'") { gem "one" }
      expect(appraisal.gemfile.to_s).to include("install_if RUBY_VERSION >= '3.0' do")
    end

    it "delegates #platforms to the gemfile" do
      appraisal.platforms(:ruby) { gem "one" }
      expect(appraisal.gemfile.to_s).to include("platforms :ruby do")
    end

    it "delegates #gemspec to the gemfile" do
      appraisal.gemspec
      expect(appraisal.gemfile.to_s).to eq(%(gemspec path: "../"))
    end

    it "delegates #git_source to the gemfile" do
      appraisal.git_source(:custom) { |repo| "path/#{repo}" }
      appraisal.gem("bacon", custom: "bacon_pancake")
      expect(appraisal.gemfile.to_s).to eq(%(gem "bacon", git: "../path/bacon_pancake"))
    end
  end

  it "creates the gemfiles directory if it does not exist" do
    Dir.mktmpdir do |dir|
      appraisal = Appraisal::Appraisal.new("fresh", "Gemfile")
      allow(Dir).to receive(:pwd).and_return(dir)

      expect { appraisal.gemfile_path }
        .to change { File.directory?(File.join(dir, "gemfiles")) }
        .from(false).to(true)
    end
  end

  it "runs bundle update via Command" do
    appraisal = Appraisal::Appraisal.new("fake", "fake")
    allow(appraisal).to receive(:gemfile_path).and_return("fake.gemfile")
    allow(Appraisal::Command).to receive(:new).and_return(double(run: true))

    appraisal.update(["rails", "rspec"])

    expect(Appraisal::Command).to have_received(:new)
      .with(%w[bundle update rails rspec], gemfile: "fake.gemfile")
  end

  it "disables shared gems when Bundler is configured with a --path" do
    appraisal = Appraisal::Appraisal.new("fake", "fake")
    allow(appraisal).to receive(:gemfile_path).and_return("fake.gemfile")
    allow(Bundler).to receive(:settings).and_return(path: "vendor/bundle")
    allow(Appraisal::Command).to receive(:new).and_return(double(run: true))

    appraisal.install

    expect(Appraisal::Command).to have_received(:new)
      .with(anything, env: { "BUNDLE_DISABLE_SHARED_GEMS" => "1" })
  end

  it "rewrites absolute paths in the lockfile to be relative" do
    Dir.mktmpdir do |dir|
      appraisal = Appraisal::Appraisal.new("fake", "fake")
      allow(Dir).to receive(:pwd).and_return(dir)
      FileUtils.mkdir_p(File.join(dir, "gemfiles"))
      lockfile_path = File.join(dir, "gemfiles", "fake.gemfile.lock")
      File.write(lockfile_path, "BUNDLE PATH: #{dir}/vendor/bundle\n")

      appraisal.relativize

      expect(File.read(lockfile_path)).to eq("BUNDLE PATH: ../vendor/bundle\n")
    end
  end

  it "converts spaces to underscores in the gemfile path" do
    appraisal = Appraisal::Appraisal.new("one two", "Gemfile")
    expect(appraisal.gemfile_path).to match(/one_two\.gemfile$/)
  end

  it "converts  punctuation to underscores in the gemfile path" do
    appraisal = Appraisal::Appraisal.new("o&ne!", "Gemfile")
    expect(appraisal.gemfile_path).to match(/o_ne_\.gemfile$/)
  end

  it "keeps dots in the gemfile path" do
    appraisal = Appraisal::Appraisal.new("rails3.0", "Gemfile")
    expect(appraisal.gemfile_path).to match(/rails3\.0\.gemfile$/)
  end

  it "generates a gemfile with a newline at the end of file" do
    output_file = Tempfile.new("gemfile")
    appraisal = Appraisal::Appraisal.new("fake", "fake")
    allow(appraisal).to receive(:gemfile_path).and_return(output_file.path)

    appraisal.write_gemfile

    expect(output_file.read).to match(/[^\n]*\n\z/m)
  end

  context "gemfile customization" do
    it "generates a gemfile with a custom heading" do
      heading = "This file was generated with a custom heading!"
      Appraisal::Customize.new(heading: heading)
      output_file = Tempfile.new("gemfile")
      appraisal = Appraisal::Appraisal.new("custom", "Gemfile")
      allow(appraisal).to receive(:gemfile_path).and_return(output_file.path)

      appraisal.write_gemfile

      expected_output = "# #{heading}"
      expect(output_file.read).to start_with(expected_output)
    end

    it "generates a gemfile with multiple lines of custom heading" do
      heading = <<~HEADING
        frozen_string_literal: true\n
        This file was generated with a custom heading!
      HEADING
      Appraisal::Customize.new(heading: heading)
      output_file = Tempfile.new("gemfile")
      appraisal = Appraisal::Appraisal.new("custom", "Gemfile")
      allow(appraisal).to receive(:gemfile_path).and_return(output_file.path)

      appraisal.write_gemfile

      expected_output = <<~HEADING
        # frozen_string_literal: true\n
        # This file was generated with a custom heading!
      HEADING
      expect(output_file.read).to start_with(expected_output)
    end

    it "generates a gemfile with single quotes rather than doubles" do
      Appraisal::Customize.new(single_quotes: true)
      output_file = Tempfile.new("gemfile")
      appraisal = Appraisal::Appraisal.new("quotes", 'gem "foo"')
      allow(appraisal).to receive(:gemfile_path).and_return(output_file.path)

      appraisal.write_gemfile

      expect(output_file.read).to match(/gem 'foo'/)
    end

    it "does not customize anything by default" do
      Appraisal::Customize.new
      output_file = Tempfile.new("gemfile")
      appraisal = Appraisal::Appraisal.new("fake", 'gem "foo"')
      allow(appraisal).to receive(:gemfile_path).and_return(output_file.path)

      appraisal.write_gemfile

      expected_file = %(# This file was generated by Appraisal\n\ngem "foo"\n)
      expect(output_file.read).to eq(expected_file)
    end
  end

  context "parallel installation" do
    include StreamHelpers

    before do
      @appraisal = Appraisal::Appraisal.new("fake", "fake")
      allow(@appraisal).to receive(:gemfile_path).and_return("/home/test/test directory")
      allow(@appraisal).to receive(:project_root).and_return(Pathname.new("/home/test"))
      allow(Appraisal::Command).to receive(:new).and_return(double(run: true))
    end

    it "runs single install command on Bundler < 1.4.0" do
      stub_const("Bundler::VERSION", "1.3.0")

      warning = capture(:stderr) do
        @appraisal.install("jobs" => 42)
      end

      expect(Appraisal::Command).to have_received(:new).with("#{bundle_check_command} || #{bundle_single_install_command}")
      expect(warning).to include "Please upgrade Bundler"
    end

    it "runs parallel install command on Bundler >= 1.4.0" do
      stub_const("Bundler::VERSION", "1.4.0")

      @appraisal.install("jobs" => 42)

      expect(Appraisal::Command).to have_received(:new).with("#{bundle_check_command} || #{bundle_parallel_install_command}")
    end

    it "runs install command with retries on Bundler" do
      @appraisal.install("retry" => 3)

      expect(Appraisal::Command).to have_received(:new).with("#{bundle_check_command} || #{bundle_install_command_with_retries}")
    end

    it "runs install command with path on Bundler" do
      @appraisal.install("path" => "vendor/appraisal")

      expect(Appraisal::Command).to have_received(:new).with("#{bundle_check_command} || #{bundle_install_command_with_path}")
    end

    def bundle_check_command
      "bundle check --gemfile='/home/test/test directory'"
    end

    def bundle_single_install_command
      "bundle install --gemfile='/home/test/test directory'"
    end

    def bundle_parallel_install_command
      "bundle install --gemfile='/home/test/test directory' --jobs=42"
    end

    def bundle_install_command_with_retries
      "bundle install --gemfile='/home/test/test directory' --retry 3"
    end

    def bundle_install_command_with_path
      "bundle install --gemfile='/home/test/test directory' " \
        "--path /home/test/vendor/appraisal"
    end
  end
end
