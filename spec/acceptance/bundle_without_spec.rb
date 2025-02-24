# frozen_string_literal: true

RSpec.describe "Bundle without group" do
  it "config set --local without group is honored by Bundler" do
    reason = "config set --local without group support seems broken, see: https://github.com/rubygems/rubygems/issues/8518"
    # Somehow this spec passes on truffleruby *only*!!
    pending_for(:engine => "ruby", :reason => reason)
    pending_for(:engine => "jruby", :reason => reason)
    build_gems %w[pancake orange_juice waffle coffee sausage soda]

    build_gemfile <<-GEMFILE.strip_heredoc.rstrip
      source "https://rubygems.org"

      gem "pancake"
      gem "rake", "~> 10.5", :platform => :ruby_18

      group :drinks do
        gem "orange_juice"
      end

      gem "appraisal", :path => #{PROJECT_ROOT.inspect}
    GEMFILE

    build_appraisal_file <<-APPRAISALS.strip_heredoc.rstrip
      appraise "breakfast" do
        gem "waffle"

        group :drinks do
          gem "coffee"
        end
      end

      appraise "lunch" do
        gem "sausage"

        group :drinks do
          gem "soda"
        end
      end
    APPRAISALS

    run "bundle install --local"
    run "bundle config set --local without 'drinks'"
    output = run "appraisal install"

    expect(output).to include("Bundle complete")
    expect(output).not_to include("orange_juice")
    expect(output).not_to include("coffee")
    expect(output).not_to include("soda")

    output = run "appraisal install"

    expect(output).to include("The Gemfile's dependencies are satisfied")
  end
end
