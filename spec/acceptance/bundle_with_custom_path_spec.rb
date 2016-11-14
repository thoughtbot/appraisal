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

  context 'when already installed in vendor/another' do
    let(:gem_name) { 'rack' }
    let(:path) { 'vendor/bundle' }

    before do
      build_gemfile <<-Gemfile
        source "https://rubygems.org"

        gem '#{gem_name}'
      Gemfile

      run 'bundle install --path vendor/another'
    end

    it 'installs gems in the --path directory' do
      build_gemfile <<-Gemfile
        source "https://rubygems.org"

        gem 'appraisal', :path => #{PROJECT_ROOT.inspect}

        if RUBY_VERSION < "1.9"
          #{File.read(File.join(PROJECT_ROOT, "Gemfile-1.8"))}
        elsif RUBY_VERSION < "2.2"
          #{File.read(File.join(PROJECT_ROOT, "Gemfile-2.1"))}
        end
      Gemfile

      build_appraisal_file <<-Appraisals
        appraise "#{gem_name}" do
          gem '#{gem_name}'
        end
      Appraisals

      run %(bundle install --path="#{path}")
      run 'bundle exec appraisal install'

      installed_gem = Dir.glob("tmp/stage/#{path}/ruby/*/gems/*").
                      map    { |path| path.split('/').last }.
                      select { |gem| gem.include?(gem_name) }
      expect(installed_gem).not_to be_empty

      bundle_output = run 'bundle check'
      expect(bundle_output).to include("The Gemfile's dependencies are satisfied")

      appraisal_output = run 'bundle exec appraisal install'
      expect(appraisal_output).to include("The Gemfile's dependencies are satisfied")
    end
  end
end
