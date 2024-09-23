# frozen_string_literal: true

require "spec_helper"

RSpec.describe "CLI", "appraisal clean" do
  it "remove all gemfiles from gemfiles directory" do
    build_appraisal_file <<-APPRAISAL
      appraise '1.0.0' do
        gem 'dummy', '1.0.0'
      end
    APPRAISAL

    run "appraisal install"
    write_file "gemfiles/non_related_file", ""

    run "appraisal clean"

    expect(file("gemfiles/1.0.0.gemfile")).not_to be_exists
    expect(file("gemfiles/1.0.0.gemfile.lock")).not_to be_exists
    expect(file("gemfiles/non_related_file")).to be_exists
  end
end
