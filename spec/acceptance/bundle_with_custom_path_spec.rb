# frozen_string_literal: true

RSpec.describe "Bundle with custom path" do
  let(:gem_name) { "rack" }
  let(:path) { "vendor/bundle" }

  shared_examples "gemfile dependencies are satisfied" do
    it "installs gems in the --path directory" do
      build_gemfile <<-GEMFILE.strip_heredoc.rstrip
        source "https://rubygems.org"

        gem 'appraisal', :path => #{PROJECT_ROOT.inspect}

        if RUBY_VERSION < "1.9"
          #{File.read(File.join(PROJECT_ROOT, "Gemfile-1.8"))}
        elsif RUBY_VERSION < "2.2"
          #{File.read(File.join(PROJECT_ROOT, "Gemfile-2.1"))}
        end
      GEMFILE

      build_appraisal_file <<-APPRAISALS.strip_heredoc.rstrip
        appraise "#{gem_name}" do
          gem '#{gem_name}'
        end
      APPRAISALS

      run "bundle config set --local path #{path}"
      run "bundle install"
      run "bundle exec appraisal install"

      installed_gem = Dir.glob("tmp/stage/#{path}/#{Gem.ruby_engine}/*/gems/*")
        .map { |path| path.split("/").last }
        .select { |gem| gem.include?(gem_name) }
      expect(installed_gem).not_to be_empty

      bundle_output = run "bundle check"
      expect(bundle_output).to include("The Gemfile's dependencies are satisfied")

      appraisal_output = run "bundle exec appraisal install"
      expect(appraisal_output).to include("The Gemfile's dependencies are satisfied")

      run "bundle config unset --local path"
    end
  end

  include_examples "gemfile dependencies are satisfied"

  context "when already installed in vendor/another" do
    before do
      build_gemfile <<-GEMFILE.strip_heredoc.rstrip
        source "https://rubygems.org"

        if RUBY_VERSION <= "1.9"
          gem '#{gem_name}', '~> 1.6.5'
        else
          gem '#{gem_name}'
        end
      GEMFILE

      run "bundle config set --local path vendor/another"
      run "bundle install"
      run "bundle config unset --local path"
    end

    include_examples "gemfile dependencies are satisfied"
  end
end
