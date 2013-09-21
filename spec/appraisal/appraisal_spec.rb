require 'spec_helper'
require 'appraisal/appraisal'
require 'tempfile'
require 'active_support/core_ext/kernel/reporting'

describe Appraisal::Appraisal do
  it "converts spaces to underscores in the gemfile path" do
    appraisal = Appraisal::Appraisal.new("one two", "Gemfile")
    appraisal.gemfile_path.should =~ /one_two\.gemfile$/
  end

  it "converts  punctuation to underscores in the gemfile path" do
    appraisal = Appraisal::Appraisal.new("o&ne!", "Gemfile")
    appraisal.gemfile_path.should =~ /o_ne_\.gemfile$/
  end

  it "keeps dots in the gemfile path" do
    appraisal = Appraisal::Appraisal.new("rails3.0", "Gemfile")
    appraisal.gemfile_path.should =~ /rails3\.0\.gemfile$/
  end

  context 'gemfiles generation' do
    before do
      @output = Tempfile.new('output')
    end

    after do
      @output.close
      @output.unlink
    end

    it 'generates a gemfile with a newline at the end of file' do
      appraisal = Appraisal::Appraisal.new('fake', 'fake')
      appraisal.stub(:gemfile_path) { @output.path }
      appraisal.write_gemfile
      @output.read.should =~ /[^\n]*\n\z/m
    end
  end

  context 'parallel installation' do
    before do
      @appraisal = Appraisal::Appraisal.new('fake', 'fake')
      @appraisal.stub(:gemfile_path).and_return("/home/test/test directory")
      Appraisal::Command.stub(:new => double(:run => true))
    end

    it 'runs single install command on Bundler < 1.4.0' do
      stub_const('Bundler::VERSION', '1.3.0')

      warning = capture(:stderr) do
        @appraisal.install(42)
      end

      Appraisal::Command.should have_received(:new).
        with("#{bundle_check_command} || #{bundle_single_install_command}")
      warning.should include 'Please upgrade Bundler'
    end

    it 'runs parallel install command on Bundler >= 1.4.0' do
      stub_const('Bundler::VERSION', '1.4.0')

      @appraisal.install(42)

      Appraisal::Command.should have_received(:new).
        with("#{bundle_check_command} || #{bundle_parallel_install_command}")
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
  end
end
