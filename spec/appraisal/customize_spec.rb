require "spec_helper"
require "appraisal/appraisal"
require "appraisal/customize"

describe Appraisal::Customize do
  let(:appraisal) { Appraisal::Appraisal.new("test", "Gemfile") }
  let(:single_line_heading) { "This file was generated with a custom heading!" }
  let(:multi_line_heading) do
    <<~HEADING
      frozen_string_literal: true

      This file was generated with a custom heading!
    HEADING
  end
  let(:subject) { described_class.new }
  let(:single_line_subject) do
    described_class.new(heading: single_line_heading)
  end
  let(:multi_line_single_quotes_subject) do
    described_class.new(heading: multi_line_heading, single_quotes: true)
  end

  describe ".heading" do
    it "returns nil if no heading is set" do
      subject
      expect(described_class.heading(appraisal)).to eq(nil)
    end

    it "returns the heading if set" do
      single_line_subject
      expect(described_class.heading(appraisal)).to eq(single_line_heading)
    end

    it "returns the heading without an trailing newline" do
      multi_line_single_quotes_subject
      expect(described_class.heading(appraisal)).to eq(multi_line_heading.chomp)
      expect(described_class.heading(appraisal)).to_not end_with("\n")
    end
  end

  describe ".single_quotes" do
    it "returns false if not set" do
      subject
      expect(described_class.single_quotes).to eq(false)
    end

    it "returns true if set" do
      multi_line_single_quotes_subject
      expect(described_class.single_quotes).to eq(true)
    end
  end

  describe ".customize" do
    let(:gemfile) { "test.gemfile" }
    let(:relative_path) { "gemfiles/#{gemfile}" }
    let(:full_path) { "/path/to/project/#{relative_path}" }
    before do
      allow(appraisal).to receive(:gemfile_name).and_return(gemfile)
      allow(appraisal).to receive(:gemfile_path).and_return(full_path)
      allow(appraisal).to receive(:relative_gemfile_path).
        and_return(relative_path)
    end

    it "returns nil if no heading is set" do
      subject
      expect(described_class.send(:customize, nil, appraisal)).to eq(nil)
    end

    it "returns the heading unchanged" do
      single_line_subject
      expect(described_class.send(
               :customize,
               single_line_heading,
               appraisal,
             )).to eq(single_line_heading)
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
               "Gemfile: %{gemfile_path}", # rubocop:disable Style/FormatStringToken, Metrics/LineLength
               appraisal,
             )).to eq("Gemfile: #{full_path}")
    end

    it "returns the heading with the relative gemfile path" do
      expect(described_class.send(
               :customize,
               "Gemfile: %{relative_gemfile_path}", # rubocop:disable Style/FormatStringToken, Metrics/LineLength
               appraisal,
             )).to eq("Gemfile: #{relative_path}")
    end
  end
end
