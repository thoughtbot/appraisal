require "spec_helper"

describe "Bundle with custom path" do
  it "supports --path option" do
    build_gemfile <<-Gemfile
      source "https://rubygems.org"

      gem 'appraisal', :path => #{PROJECT_ROOT.inspect}
    Gemfile

    build_appraisal_file <<-Appraisals
      appraise "breakfast" do
      end
    Appraisals

    run %(bundle install --path="vendor/bundle")
    output = run "appraisal install"

    expect(file "gemfiles/breakfast.gemfile").to be_exists
    expect(output).to include("Successfully installed bundler")
  end
end
