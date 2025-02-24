# frozen_string_literal: true

require "spec_helper"
require "appraisal/appraisal"
require "appraisal/customize"

RSpec.describe Appraisal::Customize do
  let(:appraisal) { Appraisal::Appraisal.new("test", "Gemfile") }
  let(:single_line_heading) { "This file was generated with a custom heading!" }
  let(:multi_line_heading) do
    <<-HEADING.strip_heredoc.rstrip
      frozen_string_literal: true

      This file was generated with a custom heading!
    HEADING
  end
  let(:subject) { described_class.new }
  let(:single_line_subject) do
    described_class.new(:heading => single_line_heading)
  end
  let(:multi_line_single_quotes_subject) do
    described_class.new(:heading => multi_line_heading, :single_quotes => true)
  end

  describe ".heading" do
    it "returns nil if no heading is set" do
      subject
      expect(described_class.heading(appraisal)).to be_nil
    end

    it "returns the heading if set" do
      single_line_subject
      expect(described_class.heading(appraisal)).to eq(single_line_heading)
    end

    it "returns the heading without an trailing newline" do
      multi_line_single_quotes_subject
      expect(described_class.heading(appraisal)).to eq(multi_line_heading.chomp)
      expect(described_class.heading(appraisal)).not_to end_with("\n")
    end
  end

  describe ".single_quotes" do
    it "returns false if not set" do
      subject
      expect(described_class.single_quotes).to be(false)
    end

    it "returns true if set" do
      multi_line_single_quotes_subject
      expect(described_class.single_quotes).to be(true)
    end
  end

  describe ".customize" do
    let(:appraisal_name) { "test" }
    let(:gemfile) { "test.gemfile" }
    let(:lockfile) { "#{gemfile}.lock" }
    let(:gemfile_relative_path) { "gemfiles/#{gemfile}" }
    let(:lockfile_relative_path) { "gemfiles/#{lockfile}" }
    let(:gemfile_full_path) { "/path/to/project/#{gemfile_relative_path}" }
    let(:lockfile_full_path) { "/path/to/project/#{lockfile_relative_path}" }

    before do
      allow(appraisal).to receive(:gemfile_name).and_return(gemfile)
      allow(appraisal).to receive(:gemfile_path).and_return(gemfile_full_path)
      allow(appraisal).to receive(:lockfile_path).and_return(lockfile_full_path)
      allow(appraisal).to receive(:relative_gemfile_path).and_return(gemfile_relative_path)
    end

    it "returns nil if no heading is set" do
      subject
      expect(described_class.send(:customize, nil, appraisal)).to be_nil
    end

    it "returns the heading unchanged" do
      single_line_subject
      expect(described_class.send(
        :customize,
        single_line_heading,
        appraisal,
      )).to eq(single_line_heading)
    end

    it "returns the heading with the appraisal name" do
      expect(described_class.send(
        :customize,
        "Appraisal: %{appraisal}", # rubocop:disable Style/FormatStringToken
        appraisal,
      )).to eq("Appraisal: #{appraisal_name}")
    end

    it "returns the heading with the gemfile name" do
      expect(described_class.send(
        :customize,
        "Gemfile: %{gemfile}", # rubocop:disable Style/FormatStringToken
        appraisal,
      )).to eq("Gemfile: #{gemfile}")
    end

    it "returns the heading with the gemfile path" do
      expect(described_class.send(
        :customize,
        "Gemfile: %{gemfile_path}", # rubocop:disable Style/FormatStringToken
        appraisal,
      )).to eq("Gemfile: #{gemfile_full_path}")
    end

    it "returns the heading with the lockfile name" do
      expect(described_class.send(
        :customize,
        "Lockfile: %{lockfile}", # rubocop:disable Style/FormatStringToken
        appraisal,
      )).to eq("Lockfile: #{lockfile}")
    end

    it "returns the heading with the lockfile path" do
      expect(described_class.send(
        :customize,
        "Lockfile: %{lockfile_path}", # rubocop:disable Style/FormatStringToken
        appraisal,
      )).to eq("Lockfile: #{lockfile_full_path}")
    end

    it "returns the heading with the relative gemfile path" do
      expect(described_class.send(
        :customize,
        "Gemfile: %{relative_gemfile_path}", # rubocop:disable Style/FormatStringToken
        appraisal,
      )).to eq("Gemfile: #{gemfile_relative_path}")
    end

    it "returns the heading with the relative lockfile path" do
      expect(described_class.send(
        :customize,
        "Gemfile: %{relative_lockfile_path}", # rubocop:disable Style/FormatStringToken
        appraisal,
      )).to eq("Gemfile: #{lockfile_relative_path}")
    end
  end
end
