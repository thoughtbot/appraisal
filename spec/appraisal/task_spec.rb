# frozen_string_literal: true

require "spec_helper"
require "appraisal/task"
require "rake"

RSpec.describe Appraisal::Task do
  include StreamHelpers

  around do |example|
    original_application = Rake.application
    Rake.application = Rake::Application.new
    example.run
  ensure
    Rake.application = original_application
  end

  context "when an Appraisals file exists" do
    let!(:task) do
      allow(Appraisal::AppraisalFile).to receive(:each).and_yield(double("Appraisal", name: "rails-6"))
      described_class.new
    end

    before do
      # The task blocks below run with `self` bound to this Task instance
      # (they're plain blocks defined inside #initialize), so `exec` must be
      # stubbed on the instance rather than on Kernel to intercept the call
      # before it replaces the current process.
      allow(task).to receive(:exec)
    end

    it "defines a deprecated task for generating gemfiles" do
      warning = capture(:stderr) { Rake::Task["appraisal:gemfiles"].invoke }

      expect(warning).to include("deprecated")
      expect(task).to have_received(:exec).with("bundle exec appraisal generate")
    end

    it "defines a deprecated task for installing dependencies" do
      warning = capture(:stderr) { Rake::Task["appraisal:install"].invoke }

      expect(warning).to include("deprecated")
      expect(task).to have_received(:exec).with("bundle exec appraisal install")
    end

    it "defines a deprecated task for cleaning up generated gemfiles" do
      warning = capture(:stderr) { Rake::Task["appraisal:cleanup"].invoke }

      expect(warning).to include("deprecated")
      expect(task).to have_received(:exec).with("bundle exec appraisal clean")
    end

    it "defines a deprecated task for each appraisal" do
      stub_const("ARGV", ["rails-6", "spec"])

      warning = capture(:stderr) { Rake::Task["appraisal:rails-6"].invoke }

      expect(warning).to include("deprecated")
      expect(task).to have_received(:exec).with("bundle exec appraisal rails-6 rake spec")
    end

    it "defines a task that runs the given rake task for every appraisal" do
      stub_const("ARGV", ["all", "spec"])

      Rake::Task["appraisal:all"].invoke

      expect(task).to have_received(:exec).with("bundle exec appraisal rake spec")
    end

    it "defines a top-level task delegating to appraisal:all" do
      stub_const("ARGV", ["appraisal", "spec"])

      Rake::Task["appraisal"].invoke

      expect(task).to have_received(:exec).with("bundle exec appraisal rake spec")
    end
  end

  context "when no Appraisals file exists" do
    before do
      allow(Appraisal::AppraisalFile).to receive(:each).and_raise(Appraisal::AppraisalsNotFound)
    end

    it "does not raise and still defines the top-level tasks" do
      expect { described_class.new }.not_to raise_error

      expect(Rake::Task.task_defined?("appraisal:all")).to eq(true)
      expect(Rake::Task.task_defined?("appraisal")).to eq(true)
    end
  end
end
